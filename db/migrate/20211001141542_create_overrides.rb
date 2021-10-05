class CreateOverrides < ActiveRecord::Migration[6.0]
  def change
    create_table :foreman_patch_overrides do |t|
      t.integer :user_id, null: false
      t.integer :source_id, null: false
      t.integer :target_id
      t.text :reason
      t.timestamps
    end

    add_index :foreman_patch_overrides, :user_id, name: :foreman_patch_override_by_user_id
    add_index :foreman_patch_overrides, :source_id, name: :foreman_patch_override_by_source_id
    add_index :foreman_patch_overrides, :target_id, name: :foreman_patch_override_by_target_id

    add_foreign_key :foreman_patch_overrides, :foreman_patch_invocations, column: :source_id, name: :foreman_patch_override_by_source, on_delete: :cascade
    add_foreign_key :foreman_patch_overrides, :foreman_patch_invocations, column: :target_id, name: :foreman_patch_override_by_target, on_delete: :nullify
    add_foreign_key :foreman_patch_overrides, :users, column: :user_id, name: :foreman_patch_override_by_user

  end
end
