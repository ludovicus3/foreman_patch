module ForemanPatch
  class Invocation < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    belongs_to :round, class_name: 'ForemanPatch::Round', inverse_of: :invocations
    has_one :window, through: :round

    belongs_to :host, class_name: 'Host::Managed'

    belongs_to :task, class_name: 'ForemanTasks::Task'

    scope :planned, -> { where(status: 'planned') }
    scope :pending, -> { where(status: 'pending') }
    scope :running, -> { where(status: 'running') }
    scope :successful, -> { where(status: 'success') }
    scope :warning, -> { where(status: 'warning') }
    scope :failed, -> { where(status: 'failed') }
    scope :cancelled, -> { where(status: 'cancelled') }

    scoped_search relation: :host, on: :name, complete_value: true

    default_scope { includes(:host).order('hosts.name') }

    def phases
      task&.main_action&.planned_actions || []
    end

    def state
      return 'scheduled' if task.nil?
      task.state
    end

    def result
      return 'pending' if task.nil?
      task.result
    end

    def complete?
      ['success', 'warning', 'failed', 'cancelled'].include? status
    end

    def warning?
      status == 'warning'
    end

    def failed?
      status == 'failed'
    end

    def success?
      status == 'success'
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
