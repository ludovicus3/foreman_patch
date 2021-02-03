module ForemanPatch
  class Group < ::ApplicationRecord
    belongs_to :default_window, class_name: 'ForemanPatch::WindowPlans'

    has_many :window_groups, class_name: 'ForemanPatch::WindowGroup', foreign_key: :group_id, inverse_of: :group
    has_many :windows, through: :window_groups

    has_many :group_facets, class_name: 'ForemanPatch::Host::GroupFacet', foreign_key: :group_id, inverse_of: :group
    has_many :hosts, through: :group_facets

    validates :name, presence: true, uniqueness: true
  end
end

