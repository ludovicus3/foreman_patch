module ForemanPatch
  class Invocation < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    belongs_to :round, class_name: 'ForemanPatch::Round', inverse_of: :invocations
    has_one :window, through: :round

    belongs_to :host, class_name: 'Host::Managed'

    belongs_to :task, class_name: 'ForemanTasks::Task'

    scope :pending, -> { left_joins(:task).where(foreman_tasks_tasks: { result: [nil, 'pending'] }) }
    scope :failed, -> { left_joins(:task).where(foreman_tasks_tasks: { result: 'failed' }) }
    scope :warning, -> { left_joins(:task).where(foreman_tasks_tasks: { result: 'warning' }) }
    scope :successful, -> { left_joins(:task).where(foreman_tasks_tasks: { result: 'success' }) }
    scope :cancelled, -> { left_joins(:task).where(foreman_tasks_tasks: { result: 'cancelled' }) }

    scoped_search relation: :host, on: :name, complete_value: true

    default_scope { includes(:host).order('hosts.name') }

    def phases
      task.main_action.planned_actions unless task.blank?
    end

    def state
      return 'pending' if task.nil?
      task.state
    end

    def result
      return 'pending' if task.nil?
      task.result
    end

    def warning?
      state == 'stopped' and result == 'warning'
    end

    def failed?
      state == 'stopped' and result == 'error'
    end

    def success?
      state == 'stopped' and result == 'success'
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
