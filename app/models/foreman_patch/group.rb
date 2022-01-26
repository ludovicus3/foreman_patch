module ForemanPatch
  class Group < ::ApplicationRecord
    include Katello::Ext::LabelFromName
    include ForemanTasks::Concerns::ActionSubject
    extend FriendlyId
    friendly_id :label

    include Authorizable

    belongs_to :default_window_plan, class_name: 'ForemanPatch::WindowPlan'

    has_many :group_facets, class_name: 'ForemanPatch::Host::GroupFacet', foreign_key: :group_id, inverse_of: :group, dependent: :nullify
    has_many :hosts, through: :group_facets

    has_many :rounds, class_name: 'ForemanPatch::Round', foreign_key: :group_id, dependent: :nullify

    validates_lengths_from_database except: [:label]
    validates :name, presence: true, uniqueness: true
    validates :label, uniqueness: true,
      presence: true

    validates_with Katello::Validators::KatelloNameFormatValidator, attributes: :name
    validates_with Katello::Validators::KatelloLabelFormatValidator, attributes: :label

    scoped_search on: :id, complete_value: false
    scoped_search on: :name, complete_value: true
    scoped_search on: :label, complete_value: true
    scoped_search on: :default_window_plan_id, complete_value: true, rename: :default_window_id
    scoped_search on: :priority, complete_value: true

    scoped_search relation: :default_window_plan, on: :name, complete_value: true, rename: :default_window

    def hosts_count
      hosts.count
    end

    class Jail < Safemode::Jail
      allow :id, :name, :label, :default_window_plan, :hosts
    end

  end
end

