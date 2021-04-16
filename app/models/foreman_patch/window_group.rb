module ForemanPatch
  class WindowGroup < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    belongs_to :window, class_name: 'ForemanPatch::Window'
    belongs_to :group, class_name: 'ForemanPatch::Group'

    belongs_to :task, class_name: 'ForemanTasks::Task'
    has_many :sub_tasks, through: :task

    validates :window, presence: true
    validates :group, presence: true, uniqueness: { scope: :window }

    delegate :name, :max_unavailable, to: :group

    has_many :invocations, class_name: 'ForemanPatch::Invocation', foreign_key: :window_group_id, inverse_of: :window_group

    before_create :ensure_priority

    def invocation_for_host(host)
      invocations.find_or_create_by!(host: host) if group.hosts.include?(host)
    end

    private

    def ensure_priority
      self.priority = group.default_priority if priority.nil?
    end
  end
end

