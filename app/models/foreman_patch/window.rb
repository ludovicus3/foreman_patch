module ForemanPatch
  class Window < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject
    include Foreman::ObservableModel

    belongs_to :cycle, class_name: 'ForemanPatch::Cycle', inverse_of: :windows

    belongs_to :task, class_name: 'ForemanTasks::Task'
    has_many :sub_tasks, through: :task

    has_many :rounds, -> { order(priority: :asc) }, class_name: 'ForemanPatch::Round', inverse_of: :window, dependent: :destroy
    has_many :groups, through: :rounds
    has_many :invocations, through: :rounds
    has_many :hosts, through: :rounds

    validates :cycle, presence: true
    validates :name, presence: true
    validates :start_at, presence: true
    validates :end_by, presence: true

    scope :planned, -> { where(status: 'planned') }
    scope :scheduled, -> { where(status: 'scheduled') }
    scope :running, -> { where(status: 'running') }
    scope :completed, -> { where(status: 'completed') }

    scope :with_status, -> (*args) { where(status: args.flatten) }
    scope :with_hosts, -> (*args) do
      left_joins(rounds: [:invocations, {group: :group_facets}]).scoping do
        where(foreman_patch_group_facets: { host_id: args.flatten })
          .or(where(foreman_patch_invocations: { host_id: args.flatten }))
      end.distinct
    end

    scoped_search on: :name, complete_value: true
    scoped_search on: :start_at, complete_value: false
    scoped_search on: :end_by, complete_value: false
    scoped_search on: :cycle_id, complete_value: false
    scoped_search on: :status, complete_value: true
    scoped_search relation: :cycle, on: :name, complete_value: true, rename: 'cycle', only_explicit: true

    after_update :reschedule, if: :needs_reschedule?
    after_update :republish, if: :needs_republish?
    
    set_crud_hooks :patch_window

    def ticket
      @ticket ||= Ticket.get(self)
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
      self.start_at = self.start_at + duration
      self.end_by = self.end_by + duration
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

    def published?
      not ticket_id.blank?
    end

    private

    def needs_reschedule?
      scheduled? and (saved_changes.keys & ['start_at', 'end_by']).any?
    end

    def reschedule
      User.as_anonymous_admin do
        task.cancel
        task.destroy

        ::ForemanTasks.delay(::Actions::ForemanPatch::Window::Patch, delay_options, self)
      end
    end

    def needs_republish?
      published? and (saved_changes.keys - ['ticket_id', 'updated_at']).any?
    end

    def republish
      User.as_anonymous_admin do
        ::ForemanTasks.async_task(::Actions::ForemanPatch::Window::Publish, self)
      end
    end

    def delay_options
      {
        start_at: start_at,
        start_before: end_by,
      }
    end

  end
end

