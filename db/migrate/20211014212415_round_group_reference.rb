class RoundGroupReference < ActiveRecord::Migration[6.0]
  def change
    add_column :foreman_patch_rounds, :group_id, :integer

    add_index :foreman_patch_rounds, :group_id, name: :foreman_patch_rounds_by_group_id

    add_foreign_key :foreman_patch_rounds, :foreman_patch_groups, column: :group_id, name: :foreman_patch_rounds_by_group
  end
end
