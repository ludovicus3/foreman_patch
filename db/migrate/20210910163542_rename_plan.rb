class RenamePlan < ActiveRecord::Migration[6.0]
  def change
    rename_column :foreman_patch_cycles, :cycle_plan_id, :plan_id
    rename_column :foreman_patch_window_plans, :cycle_plan_id, :plan_id

    rename_table :foreman_patch_cycle_plans, :foreman_patch_plans
  end
end
