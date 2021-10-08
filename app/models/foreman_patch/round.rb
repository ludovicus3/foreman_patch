module ForemanPatch
  class Round < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    belongs_to :window, class_name: 'ForemanPatch::Window'

    belongs_to :task, class_name: 'ForemanTasks::Task'
    has_many :sub_tasks, through: :task

    validates :window, presence: true

    has_many :invocations, class_name: 'ForemanPatch::Invocation', foreign_key: :round_id, inverse_of: :round, dependent: :destroy
    has_many :hosts, through: :invocations

    scoped_search on: :name, complete_value: true

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
      map = invocations.reduce({
        pending: 0,
        success: 0,
        failed: 0,
        cancelled: 0,
      }) do |hash, invocation|
        case invocation.result
        when 'error', 'warning'
          hash[:failed] += 1
        when 'success'
          hash[:success] += 1
        when 'cancelled'
          hash[:cancelled] += 1
        else
          hash[:pending] += 1
        end

        hash
      end
      map
    end

    def finished?
      !(task.nil? || task.pending?)
    end

    class Jail < ::Safemode::Jail
      allow :id, :name, :description, :invocations, :hosts, :priority, :max_unavailable, :status 
    end

    private

  end
end

