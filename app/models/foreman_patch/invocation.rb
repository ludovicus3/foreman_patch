module ForemanPatch
  class Invocation < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    belongs_to :round, class_name: 'ForemanPatch::Round', inverse_of: :invocations

    belongs_to :host, class_name: 'Host::Managed'

    belongs_to :task, class_name: 'ForemanTasks::Task'

    scope :with_round, ->(round) { where(round_id: round_id) }

    scoped_search relation: :host, on: :name, rename: 'host.name', complete_value: true

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

    def pending?
      status == HostStatus::ExecutionStatus::RUNNING
    end

    def failed?
      status == HostStatus::ExecutionStatus::ERROR
    end

    def success?
      status == HostStatus::ExecutionStatus::OK
    end

    def to_action_input
      {
        id: id,
        name: host.name
      }
    end

    class Jail < ::Safemode::Jail
      allow :id, :host, :status
    end
  end
end
