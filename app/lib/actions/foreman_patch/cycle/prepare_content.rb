module Actions
  module ForemanPatch
    module Cycle
      class PrepareContent < Actions::EntryAction
        include ::Katello::ContentViewHelper

        def humanized_name
          _('Minor Version Update')
        end

        def plan(old_version, description)
          action_subject(old_version.content_view)

          new_minor = old_version.content_view.versions.where(major: old_version.major).maximum(:minor) + 1

          components = []

          sequence do
            if old_version.content_view.composite?
              components = update_components(old_version.components, description)
            end

            new_version = old_version.content_view.create_new_version(old_version.major, new_minor, components)

            history = ::Katello::ContentViewHistory.create!(content_view_version: new_version,
                                                            user: ::User.current.login,
                                                            action: ::Katello::ContentViewHistory.actions[:publish],
                                                            status: ::Katello::ContentViewHistory::IN_PROGRESS,
                                                            task: self.task,
                                                            notes: description)

            repositories = collect_repositories(old_version, components)

            repository_mapping = plan_action(Actions::Katello::ContentViewVersion::CreateRepos,
                                             new_version, repositories).repository_mapping

            separated_repo_map = separated_repo_mapping(repository_mapping, true)

            if separated_repo_map[:pulp3_yum_multicopy].keys.flatten.present? &&
                SmartProxy.pulp_primary.pulp3_support?(separated_repo_map[:pulp3_yum_multicopy].keys.flatten.first)
              
              plan_action(Actions::Katello::Repository::MultiCloneToVersion, separated_repo_map[:pulp3_yum_multicopy], new_version)
            end

            concurrence do
              repositories.each do |repository|
                plan_action(Actions::Katello::Repository::CloneToVersion,
                            repository, new_version, repository_mapping[repository])
              end
            end

            plan_self(new_version_id: new_version.id,
                      history_id: history.id,
                      old_version_id: old_version.id)
            plan_action(Actions::Katello::ContentView::Promote, new_version, old_version.environments, true)
          end
        end

        def finalize
          new_version.update_content_counts!

          history.status = ::Katello::ContentViewHistory::SUCCESSFUL
          history.save!
        end

        def new_version
          @new_version ||= ::Katello::ContentViewVersion.find(input[:new_version_id])
        end

        private

        def old_version
          @old_version ||= ::Katello::ContentViewVersion.find(input[:old_version_id])
        end

        def history
          @history ||= ::Katello::ContentViewHistory.find(input[:history_id])
        end

        def available_content?(version)
          version.available_packages.any? or
            version.available_errata.any? or
            ::Katello::Deb.in_repositories(version.library_repos).where.not(id: version.debs).any?
        end

        def collect_repositories(version, components)
          repositories = []
          if version.content_view.composite?
            ids = components.flat_map { |component| component.repositories.archived }.map(&:id)
            repositories = ::Katello::Repository.where(id: ids)
          else
            repositories = version.library_repos
          end
          repositories.map do |repo|
            if repo.is_a? Array
              repo
            else
              [repo]
            end
          end
        end

        def update_components(components, description)
          new_components = []
          concurrence do
            components.each do |component|
              if available_content?(component)
                new_components << plan_action(Actions::ForemanPatch::Cycle::PrepareContent,
                                              component, description).new_version
              else
                new_components << component
              end
            end
          end
          new_components
        end

      end
    end
  end
end


