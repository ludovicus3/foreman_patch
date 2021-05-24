class AddCycleEndDate < ActiveRecord::Migration[6.0]
  class CyclePlan < ActiveRecord::Base
    self.table_name = 'foreman_patch_cycle_plans'
  end

  class Cycle < ActiveRecord::Base
    self.table_name = 'foreman_patch_cycles'

    belongs_to :cycle_plan, class_name: 'CyclePlan'
  end

  def change
    add_column :foreman_patch_cycles, :end_date, :date

    Cycle.all.each do |cycle|
      cycle.start_date ||= Date.today
      if cycle.cycle_plan.blank?
        cycle.end_date = Date.today
      else
        plan = cycle.cycle_plan
        cycle.end_date = cycle.start_date + (plan.interval.send(plan.units).value / ActiveSupport::Duration::SECONDS_PER_DAY) - 1
      end
      cycle.save!
    end

    change_column_null(:foreman_patch_cycles, :start_date, false)
    change_column_null(:foreman_patch_cycles, :end_date, false)
  end
end
