module ForemanPatch
  class WindowGroup < ::ApplicationRecord
    belongs_to :window, class_name: 'ForemanPatch::Window'
    belongs_to :group, class_name: 'ForemanPatch::Group'

    validates :window, presence: true
    validates :group, presence: true
  end
end

