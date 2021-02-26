module ForemanPatch
  class WindowGroup < ::ApplicationRecord

    belongs_to :window, class_name: 'ForemanPatch::Window'
    belongs_to :group, class_name: 'ForemanPatch::Group'

    validates :window, presence: true
    validates :group, presence: true, uniqueness: { scope: :window }

    before_create :ensure_priority

    private

    def ensure_priority
      self.priority = group.default_priority if priority.nil?
    end
  end
end

