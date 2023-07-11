module ForemanPatch
  class Invocation < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    STATUSES = %w(planned pending running success warning error cancelled)

    belongs_to :round, class_name: 'ForemanPatch::Round', inverse_of: :invocations
    has_one :window, through: :round
    has_one :cycle, through: :window

    belongs_to :host, class_name: 'Host::Managed'

    belongs_to :task, class_name: 'ForemanTasks::Task'

    has_many :events, class_name: 'ForemanPatch::Events'

    scope :planned, -> { where(status: 'planned') }
    scope :pending, -> { where(status: 'pending') }
    scope :running, -> { where(status: 'running') }
    scope :successful, -> { where(status: 'success') }
    scope :warning, -> { where(status: 'warning') }
    scope :failed, -> { where(status: 'error') }
    scope :cancelled, -> { where(status: 'cancelled') }
    scope :completed, -> { where(status: ['success', 'warning', 'error', 'cancelled']) }

    scope :in_windows, -> (*args) { joins(:window).where(foreman_patch_windows: { id: args.flatten }) }

    scoped_search on: :status, complete_value: true
    scoped_search relation: :host, on: :name, complete_value: true

    default_scope { includes(:host).order('hosts.name') }

    def phases
      task&.main_action&.planned_actions || []
    end

    def complete?
      ['success', 'warning', 'failed', 'cancelled'].include? status
    end

    def warning?
      status == 'warning'
    end

    def failed?
      status == 'error'
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
