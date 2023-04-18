module ForemanPatch
  class Cycle < ::ApplicationRecord
    include ForemanTasks::Concerns::ActionSubject
    include Foreman::ObservableModel
    
    belongs_to :plan, class_name: 'ForemanPatch::Plan'

    has_many :windows, -> { order(start_at: :asc) }, class_name: 'ForemanPatch::Window', foreign_key: :cycle_id, inverse_of: :cycle, dependent: :delete_all
    has_many :rounds, through: :windows
    has_many :tasks, through: :windows
    has_many :hosts, through: :windows

    scoped_search on: :name, complete_value: true
    scoped_search on: :start_date, complete_value: false
    scoped_search on: :end_date, complete_value: false
    scoped_search on: :plan_id, complete_value: false
    scoped_search relation: :plan, on: :name, complete_value: true, rename: :plan

    validates :name, presence: true
    validates :start_date, presence: true
    validates :end_date, presence: true

    scope :planned, -> { where('start_date > ?', Date.current) }
    scope :active, -> { where('end_date >= ?', Date.current) }
    scope :running, -> { where('? BETWEEN start_date AND end_date', Date.current) }
    scope :completed, -> { where('end_date < ?', Date.current) }
    
    set_crud_hooks :patch_cycle

    def planned?
      start_date > Date.current
    end

    def active?
      end_date >= Date.current
    end

    def running?
      start_date <= Date.current and end_date >= Date.current
    end

    def completed?
      end_date < Date.current
    end

    class Jail < ::Safemode::Jail
      allow :id, :name, :description, :start_date, :end_date, :windows
    end

  end
end

