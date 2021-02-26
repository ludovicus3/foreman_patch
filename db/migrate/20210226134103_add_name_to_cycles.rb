class AddNameToCycles < ActiveRecord::Migration[6.0]
  class CyclePlan < ActiveRecord::Base
    self.table_name = 'foreman_patch_cycle_plans'
  end

  class Cycle < ActiveRecord::Base
    self.table_name = 'foreman_patch_cycles'

    belongs_to :cycle_plan, class_name: 'CyclePlan'
  end

  def change
    add_column(:foreman_patch_cycles, :name, :string)
    add_column(:foreman_patch_cycles, :description, :text)

    Cycle.all.each do |cycle|
      if cycle.cycle_plan_id?
        cycle.name = cycle.cycle_plan.name
        cycle.description = cycle.cycle_plan.description
      else
        cycle.name = 'Unnamed'
      end

      cycle.save!
    end

    change_column_null(:foreman_patch_cycles, :name, false)

    add_index(:foreman_patch_cycles, :name, name: :foreman_patch_cycles_name_idx )
  end
end
