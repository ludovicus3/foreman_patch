class RenameGroupPriority < ActiveRecord::Migration[6.0]
  def change
    rename_column(:foreman_patch_groups, :default_priority, :priority)
  end
end
