class RenameDefaultWindow < ActiveRecord::Migration[6.0]
  def change
    rename_column :foreman_patch_groups, :default_window_id, :default_window_plan_id
  end
end
