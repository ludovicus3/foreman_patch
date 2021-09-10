class RenameRound < ActiveRecord::Migration[6.0]
  def change
    rename_column :foreman_patch_invocations, :window_group_id, :round_id

    rename_table :foreman_patch_window_groups, :foreman_patch_rounds
  end
end
