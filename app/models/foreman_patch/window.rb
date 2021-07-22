module ForemanPatch
  class Window < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    belongs_to :window_plan, class_name: 'ForemanPatch::WindowPlan'

    belongs_to :cycle, class_name: 'ForemanPatch::Cycle', inverse_of: :windows

    belongs_to :task, class_name: 'ForemanTasks::Task'
    has_many :sub_tasks, through: :task

    belongs_to :task_group, class_name: 'ForemanPatch::WindowTaskGroup'
    has_many :tasks, through: :task_group, class_name: 'ForemanTasks::Task'

    belongs_to :triggering, class_name: 'ForemanTasks::Triggering'

    has_many :window_groups, -> { order(priority: :asc) }, class_name: 'ForemanPatch::WindowGroup', inverse_of: :window
    has_many :groups, class_name: 'ForemanPatch::Group', through: :window_groups 

    validates :cycle, presence: true
    validates :name, presence: true
    validates :start_at, presence: true
    validates :end_by, presence: true

    scoped_search on: :name, complete_value: true
    scoped_search on: :start_at, complete_value: false
    scoped_search on: :end_by, complete_value: false
    scoped_search on: :cycle_id, complete_value: false
    scoped_search relation: :cycle, on:  :name, complete_value: true, rename: 'cycle', only_explicit: true
    scoped_search on: :window_plan_id, complete_value: false
    scoped_search relation: :window_plan, on: :name, complete_value: true, rename: 'window_plan', only_explicit: true
    scoped_search on: :state, complete_value: true

    before_validation :build_from_window_plan, if: :window_plan_id?
    after_create :load_groups_from_window_plan, if: :window_plan_id?
    before_save :publish

    def ticket
      return @ticket if defined? @ticket

      unless ticket_id.blank?
        @ticket = ForemanPatch::Ticket.load(self)
      end
      @ticket
    end

    def publish
      @ticket = ForemanPatch::Ticket.save(self)

      self.ticket_id = @ticket.fetch(Setting[:ticket_id_field], ticket_id)

      @ticket
    end

    def state
      if task.nil?
        'planned'
      else
        task.state
      end
    end

    class Jail < ::Safemode::Jail
      allow :id, :name, :description, :cycle, :start_at, :end_by, :window_groups
    end

    private

    def build_from_window_plan
      self.name = window_plan.name if name.nil?
      self.description = window_plan.description if description.nil?

      offset = window_plan.start_time.seconds_since_midnight.seconds
      self.start_at = (cycle.start_date + window_plan.start_day) + offset if start_at.nil?
      self.end_by = start_at + window_plan.duration if end_by.nil?
    end

    def load_groups_from_window_plan
      window_plan.groups.each do |group|
        window_groups.create(group: group)
      end
    end

  end
end

