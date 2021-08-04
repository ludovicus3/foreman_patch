class AddCyclePlanTaskGroup < ActiveRecord::Migration[6.0]
  def change
    add_column :foreman_patch_cycle_plans, :task_group_id, :integer

    add_foreign_key :foreman_patch_cycle_plans, :foreman_tasks_task_groups, column: :task_group_id
  end
end
