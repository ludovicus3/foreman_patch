module Actions
  module ForemanPatch
    module Host
      class BulkReschedule < Actions::EntryAction

        def plan(hosts)
          hosts = ::Host.where(id: hosts)

          rounds = ::ForemanPatch::Round.where(group: ::ForemanPatch::Group.joins(:hosts).where(hosts: { id: hosts }))

          windows = ::ForemanPatch::Window.planned.joins(:hosts).where(hosts: { id: hosts }).distinct +
            ::ForemanPatch::Window.planned.where(rounds: rounds).distinct

          plan_action(Actions::BulkAction, Actions::ForemanPatch::Host::Reschedule, hosts)
          plan_action(Actions::BulkAction, Actions::ForemanPatch::Window::Publish, windows)
        end

      end
    end
  end
end

