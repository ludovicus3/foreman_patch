module ForemanPatch
  class WindowGroup < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    belongs_to :window, class_name: 'ForemanPatch::Window'
    belongs_to :group, class_name: 'ForemanPatch::Group'

    belongs_to :task, class_name: 'ForemanTasks::Task'
    has_many :sub_tasks, through: :task

    validates :window, presence: true
    validates :group, uniqueness: { scope: :window_id }, allow_nil: true

    has_many :invocations, class_name: 'ForemanPatch::Invocation', foreign_key: :window_group_id, inverse_of: :window_group
    has_many :hosts, through: :invocations

    scoped_search on: :name, complete_value: true

    before_create :ensure_priority

    def status
      HostStatus::ExecutionStatus::ExecutionTaskStatusMapper.new(task).status
    end

    def status_label
      HostStatus::ExecutionStatus::ExecutionTaskStatusMapper.new(task).status_label
    end

    def progress(total = nil, done = nil)
      if queued? || invocations.empty? || done == 0
        0
      else
        total ||= invocations.count
        done ||= sub_tasks.where(result: %w(success warning error)).count
        ((done.to_f / total) * 100).round
      end
    end

    def queued?
      status == HostStatus::ExecutionStatus::QUEUED
    end

    def progress_report
      map = TemplateInvocation::TaskResultMap
      all_keys = (map.results | map.statuses | [:progress, :total])
      if queued? || (task && task.started_at.nil?) || invocations.empty?
        all_keys.reduce({}) do |acc, key|
          acc.merge(key => 0)
        end
      else
        counts = task.sub_tasks_counts
        done = counts.values_at(*map.results).reduce(:+)
        percent = progress(counts[:total], done)
        counts.merge(progress: percent, failed: counts.values_at(*map.status_to_task_result(:failed)).reduce(:+))
      end
    end

    def finished?
      !(task.nil? || task.pending?)
    end

    def resolve_hosts!
      group.hosts.each do |host|
        invocations.find_or_create_by!(host: host)
      end
    end

    private

    def ensure_priority
      self.priority = group.default_priority if priority.nil?
    end
  end
end

