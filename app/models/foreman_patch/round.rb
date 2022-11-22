module ForemanPatch
  class Round < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    belongs_to :window, class_name: 'ForemanPatch::Window'
    has_one :cycle, class_name: 'ForemanPatch::Cycle', through: :window
    belongs_to :group, class_name: 'ForemanPatch::Group'

    belongs_to :task, class_name: 'ForemanTasks::Task'
    has_many :sub_tasks, through: :task

    validates :window, presence: true

    has_many :invocations, class_name: 'ForemanPatch::Invocation', foreign_key: :round_id, inverse_of: :round, dependent: :destroy
    has_many :hosts, through: :invocations

    scope :planned, -> { where(status: 'planned') }
    scope :pending, -> { where(status: 'pending') }
    scope :running, -> { where(status: 'running') }
    scope :complete, -> { where(status: 'complete') }

    scope :in_windows, -> (*args) { where(window: args.flatten) }
    scope :missing_hosts, -> (*args) do
      left_joins(group: :group_facets).scoping do
        where(foreman_patch_group_facets: { host_id: args.flatten })
        .where('NOT EXISTS (:invocations)',
               invocations: ForemanPatch::Invocation.where(host_id: args.flatten)
          .where('foreman_patch_rounds.id = foreman_patch_invocations.round_id'))
      end
    end

    scoped_search on: :name, complete_value: true
    scoped_search on: :status, complete_value: true

    def progress(total = nil, done = nil)
      if invocations.empty? || done == 0
        0
      else
        total ||= invocations.count
        done ||= sub_tasks.where(result: %w(success warning error)).count
        ((done.to_f / total) * 100).round
      end
    end

    def progress_report
      invocations.reduce({
        pending: 0,
        running: 0,
        success: 0,
        warning: 0,
        failed: 0,
        cancelled: 0,
      }) do |report, invocation|
        status = (invocation.status == 'planned' ? 'pending' : invocation.status)
        report[status.to_sym] += 1
        report
      end
    end

    def finished?
      !(task.nil? || task.pending?)
    end

    class Jail < ::Safemode::Jail
      allow :id, :name, :description, :invocations, :hosts, :priority, :max_unavailable, :status 
    end

  end
end

