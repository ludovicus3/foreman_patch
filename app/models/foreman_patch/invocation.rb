module ForemanPatch
  class Invocation < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    belongs_to :round, class_name: 'ForemanPatch::Round', inverse_of: :invocations
    has_one :window, through: :round

    belongs_to :host, class_name: 'Host::Managed'

    belongs_to :task, class_name: 'ForemanTasks::Task'

    scope :with_round, ->(round) { where(round_id: round.id) }

    scoped_search relation: :host, on: :name, complete_value: true

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

    def failed?
      state == 'stopped' and (result == 'warning' or result == 'error')
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
