class AddTaskToWindowGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :foreman_patch_window_groups, :task_id, :uuid

    add_index :foreman_patch_window_groups, :task_id, name: :foreman_patch_window_groups_task_ids
  end
end
