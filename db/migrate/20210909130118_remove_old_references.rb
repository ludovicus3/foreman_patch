class RemoveOldReferences < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :foreman_patch_windows, column: :window_plan_id
    remove_foreign_key :foreman_patch_window_groups, column: :group_id

    remove_column :foreman_patch_windows, :window_plan_id
    remove_column :foreman_patch_window_groups, :group_id

    add_index :foreman_patch_window_groups, [:window_id, :name], 
      unique: true, name: :foreman_patch_window_groups_unique_name_by_window
    add_index :foreman_patch_windows, [:cycle_id, :name], 
      unique: true, name: :foreman_patch_windows_unique_names_by_cycle
  end
end
