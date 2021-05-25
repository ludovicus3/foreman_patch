module ForemanPatch
  class Invocation < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    belongs_to :window_group, class_name: 'ForemanPatch::WindowGroup', inverse_of: :invocations

    belongs_to :host, class_name: 'Host::Managed'

    belongs_to :task, class_name: 'ForemanTasks::Task'

    scope :with_window_group, ->(window_group) { where(window_group_id: window_group_id) }

    scoped_search relation: :host, on: :name, rename: 'host.name', complete_value: true

    def failed?
      task.state == 'stopped' and task.result == 'error'
    end

    def succeeded?
      task.state == 'stopped' and task.result == 'success'
    end

    def phases
      task.main_action.planned_actions unless task.blank?
    end

    def status
      HostStatus::ExecutionStatus::ExecutionTaskStatusMapper.new(task).status
    end

    def status_label
      HostStatus::ExecutionStatus::ExecutionTaskStatusMapper.new(task).status_label
    end

    def queued?
      status == HostStatus::ExecutionStatus::QUEUED
    end

    def to_action_input
      {
        id: id,
        name: host.name
      }
    end

  end
end
