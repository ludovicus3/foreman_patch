module ForemanPatch
  class Engine < ::Rails::Engine
    engine_name 'foreman_patch'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]

    # Add any db migrations
    initializer 'foreman_patch.load_app_instance_data' do |app|
      ForemanPatch::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_patch.load_default_settings', before: :load_config_initializers do |_app|
      require_dependency File.expand_path('../../../app/models/setting/patching.rb', __FILE__)
    end

    initializer 'foreman_patch.require_dynflow', before: 'foreman_tasks.initialize_dynflow' do |_app|
      ForemanTasks.dynflow.require!
      ForemanTasks.dynflow.config.eager_load_paths << File.join(ForemanPatch::Engine.root, 'app/lib/actions/foreman_patch')
    end

    initializer 'foreman_patch.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_patch do
        requires_foreman '>= 1.16'

        register_facet ForemanPatch::Host::GroupFacet, :group_facet do
          api_view list: 'foreman_patch/api/group_facet/base_with_root', single: 'foreman_patch/api/group_facet/show'
          api_docs :group_facet_attributes, ::ForemanPatch::Api::HostGroupsController
          extend_model ForemanPatch::Concerns::GroupFacetHostExtensions
        end

        # Add permissions
        security_block :foreman_patch do
        end

      end
    end

    initializer 'foreman_patch.apipie' do
      Apipie.configuration.api_controllers_matcher << "#{ForemanPatch::Engine.root}/app/controllers/foreman_patch/api/*.rb"
      Apipie.configuration.checksum_path += ['/foreman_patch/api/']
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        ::Host::Managed.send(:include, ForemanPatch::Concerns::HostManagedExtensions)

      rescue => e
        Rails.logger.warn "ForemanPatch: skipping engine hook (#{e})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanPatch::Engine.load_seed
      end
    end

    initializer 'foreman_patch.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_patch'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end

  def self.table_name_prefix
    'foreman_patch_'
  end

  def self.use_relative_model_naming
    true
  end
end
