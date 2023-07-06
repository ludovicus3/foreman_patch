class NullifyGroupOnDelete < ActiveRecord::Migration[6.0]
  def up
    remove_foreign_key :foreman_patch_rounds, name: :foreman_patch_rounds_by_group
    add_foreign_key :foreman_patch_rounds, :foreman_patch_groups, column: :group_id, name: :foreman_patch_rounds_by_group, on_delete: :nullify
  end

  def down
    remove_foreign_key :foreman_patch_rounds, name: :foreman_patch_rounds_by_group
    add_foreign_key :foreman_patch_rounds, :foreman_patch_groups, column: :group_id, name: :foreman_patch_rounds_by_group
  end
end