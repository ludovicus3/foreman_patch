class CreateForemanPatchCycles < ActiveRecord::Migration[6.0]
  def change
    create_table :foreman_patch_cycles do |t|
      t.integer :cycle_plan_id
      t.date    :start_date

      t.timestamps
    end

    add_index :foreman_patch_cycles, :start_date, name: :foreman_patch_cycles_start_date_idx

    add_foreign_key :foreman_patch_cycles, :foreman_patch_cycle_plans, column: :cycle_plan_id, name: :foreman_patch_cycles_cycle_plan_id_fk

    create_table :foreman_patch_windows do |t|
      t.integer   :window_plan_id
      t.string    :name
      t.text      :description
      t.integer   :cycle_id, null: false
      t.timestamp :start_at
      t.timestamp :end_by
      t.string    :ticket_id
      t.uuid      :task_id
      t.integer   :task_group_id
      t.integer   :triggering_id

      t.timestamps
    end

    add_index :foreman_patch_windows, :name, name: :foreman_patch_windows_name_idx
    add_index :foreman_patch_windows, [:cycle_id, :name], unique: true, name: :foreman_patch_windows_cycle_id_name_uq

    add_foreign_key :foreman_patch_windows, :foreman_patch_window_plans, column: :window_plan_id, name: :foreman_patch_window_window_plan_id_fk
    add_foreign_key :foreman_patch_windows, :foreman_patch_cycles, column: :cycle_id, name: :foreman_patch_windows_cycle_id_fk
#    add_foreign_key :foreman_patch_windows, :foreman_tasks_tasks, column: :task_id, name: :foreman_patch_windows_task_id_fk
    add_foreign_key :foreman_patch_windows, :foreman_tasks_task_groups, column: :task_group_id, name: :foreman_patch_windows_task_group_id_fk
    add_foreign_key :foreman_patch_windows, :foreman_tasks_triggerings, column: :triggering_id, name: :foreman_patch_windows_triggering_id_fk
  end
end
