module ForemanPatch
  class Group < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject

    include Authorizable

    belongs_to :default_window_plan, class_name: 'ForemanPatch::WindowPlan'

    has_many :group_facets, class_name: 'ForemanPatch::Host::GroupFacet', foreign_key: :group_id, inverse_of: :group, dependent: :nullify
    has_many :hosts, through: :group_facets

    has_many :rounds, class_name: 'ForemanPatch::Round', foreign_key: :group_id, dependent: :nullify

    validates :name, presence: true, uniqueness: true

    scoped_search on: :id, complete_value: false
    scoped_search on: :name, complete_value: true
    scoped_search on: :default_window_plan_id, complete_value: true, rename: :default_window_id
    scoped_search on: :priority, complete_value: true

    scoped_search relation: :default_window_plan, on: :name, complete_value: true, rename: :default_window

    def hosts_count
      hosts.count
    end
  end
end

