class AddRoundStatus < ActiveRecord::Migration[6.0]
  def change
    remove_index :foreman_patch_rounds, :task_id, name: :foreman_patch_window_groups_task_ids
    remove_column :foreman_patch_rounds, :task_id, type: :uuid

    add_column :foreman_patch_rounds, :status, :string, default: 'planned', null: false
    add_index :foreman_patch_rounds, :status, name: :foreman_patch_rounds_by_status
  end
end
