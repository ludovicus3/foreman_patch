module ForemanPatch
  class WindowGroup < ::ApplicationRecord
    before_create :set_priority

    belongs_to :window, class_name: 'ForemanPatch::Window'
    belongs_to :group, class_name: 'ForemanPatch::Group'

    validates :window, presence: true
    validates :group, presence: true

    private

    def set_priority
      self.priority = group.default_priority
    end
  end
end

