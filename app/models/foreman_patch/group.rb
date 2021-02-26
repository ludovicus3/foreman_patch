module ForemanPatch
  class Group < ::ApplicationRecord
    belongs_to :default_window_plan, class_name: 'ForemanPatch::WindowPlan'

    has_many :window_groups, class_name: 'ForemanPatch::WindowGroup', foreign_key: :group_id, inverse_of: :group
    has_many :windows, through: :window_groups

    has_many :group_facets, class_name: 'ForemanPatch::Host::GroupFacet', foreign_key: :group_id, inverse_of: :group
    has_many :hosts, through: :group_facets

    validates :name, presence: true, uniqueness: true

    scoped_search on: :id, complete_value: false
    scoped_search on: :name, complete_value: true
    scoped_search on: :default_window_plan_id, complete_value: true
    scoped_search on: :priority, complete_value: true

    scoped_search relation: :default_window_plan, on: :name, complete_value: true
  end
end

