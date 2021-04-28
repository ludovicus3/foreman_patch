module ForemanPatch
  class Invocation < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    belongs_to :window_group, class_name: 'ForemanPatch::WindowGroup', inverse_of: :invocations

    belongs_to :host, class_name: 'Host::Managed'

    belongs_to :task, class_name: 'ForemanTasks::Task'

    def failed?
      task.state == 'stopped' and task.result == 'error'
    end

    def succeeded?
      task.state == 'stopped' and task.result == 'success'
    end

    def to_action_input
      {
        id: id,
        name: host.name
      }
    end

  end
end
