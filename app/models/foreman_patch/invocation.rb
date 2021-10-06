module ForemanPatch
  class Invocation < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    ERROR = -5
    WARNING = -4
    MOVED = -3
    RETRIED = -2
    CANCELLED = -1
    SUCCESS = 0
    RUNNING = 1
    PENDING = 2

    belongs_to :round, class_name: 'ForemanPatch::Round', inverse_of: :invocations
    has_one :window, through: :round

    belongs_to :host, class_name: 'Host::Managed'

    belongs_to :task, class_name: 'ForemanTasks::Task'

    has_one :override, class_name: 'ForemanPatch::Override', inverse_of: :source, foreign_key: :source_id
    has_one :original, class_name: 'ForemanPatch::Override', inverse_of: :target, foreign_key: :target_id

    scope :with_round, ->(round) { where(round_id: round.id) }

    scoped_search relation: :host, on: :name, complete_value: true

    def phases
      task.main_action.planned_actions unless task.blank?
    end

    def status
      if override
        if override.retried?
          RETRIED
        elsif override.moved?
          MOVED
        else
          CANCELLED
        end
      elsif task.nil?
        if window.task.nil? and window.task.result == 'cancelled'
          CANCELLED
        else
          PENDING
        end
      else
        case task.state
        when 'stopped'
          case task.result
          when 'error'
            ERROR
          when 'warning'
            WARNING
          when 'success'
            SUCCESS
          when 'cancelled'
            CANCELLED
          else
            PENDING
          end
        when 'running'
          RUNNING
        else
          PENDING
        end
      end
    end

    def moved?
      override and invocation.round_id != round_id
    end

    def retried?
      override and invocation.round_id == round_id
    end

    def running?
      status == RUNNING
    end

    def cancelled?
      if task.nil?
        window.task and window.task.result == 'cancelled'
      else
        task.state == 'stopped' and task.result == 'cancelled'
      end
    end

    def warning?
      return false if task.nil?

      task.state == 'stopped' and task.result == 'warning'
    end

    def failed?
      return false if task.nil?

      task.state == 'stopped' and task.result == 'error'
    end

    def success?
      return false if task.nil?

      task.state == 'stopped' and task.result == 'success'
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
