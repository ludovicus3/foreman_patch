module ForemanPatch
  class Window < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    belongs_to :cycle, class_name: 'ForemanPatch::Cycle', inverse_of: :windows

    belongs_to :task, class_name: 'ForemanTasks::Task'
    has_many :sub_tasks, through: :task

    has_many :rounds, -> { order(priority: :asc) }, class_name: 'ForemanPatch::Round', inverse_of: :window
    has_many :groups, class_name: 'ForemanPatch::Group', through: :rounds
    has_many :hosts, through: :rounds

    validates :cycle, presence: true
    validates :name, presence: true
    validates :start_at, presence: true
    validates :end_by, presence: true

    scoped_search on: :name, complete_value: true
    scoped_search on: :start_at, complete_value: false
    scoped_search on: :end_by, complete_value: false
    scoped_search on: :cycle_id, complete_value: false
    scoped_search relation: :cycle, on: :name, complete_value: true, rename: 'cycle', only_explicit: true
    scoped_search relation: :task, on: :state, rename: 'state', 
      complete_value: Hash[HostStatus::ExecutionStatus::STATUS_NAMES.values.map { |v| [v, v] }]

    after_update :reschedule_task, if: :needs_reschedule?

    def ticket
      return @ticket if defined? @ticket

      @ticket = ForemanPatch::Ticket.load(self) unless ticket_id.blank?
    end

    def state
      if task.nil?
        'planned'
      else
        task.state
      end
    end

    def duration
      end_by - start_at
    end

    def duration=(duration)
      self.end_by = start_at + duration
    end

    def move_to(time)
      span = duration
      self.start_at = time
      self.end_by = time + span
    end

    def move_by(duration)
      self.start_at = self.start_at + time
      self.end_by = self.end_by + time
    end

    class Jail < ::Safemode::Jail
      allow :id, :name, :description, :cycle, :start_at, :end_by, :rounds
    end

    def scheduled?
      (not task.blank?) and task.scheduled?
    end

    def schedule
      User.as_anonymous_admin do
        ::ForemanTasks.delay(::Actions::ForemanPatch::Window::Patch, delay_options, self) unless scheduled?
      end
    end

    def cancel(force = false)
      method = force ? :abort : :cancel
      task.send(method) unless task.blank?
    end

    private

    def needs_reschedule?
      scheduled? and (task.start_at == start_at and task.start_before == end_by)
    end

    def reschedule_task
      cancel

      schedule
    end

    def delay_options
      {
        start_at: start_at,
        start_before: end_by,
      }
    end

  end
end

