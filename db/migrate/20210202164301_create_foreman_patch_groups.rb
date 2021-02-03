class CreateForemanPatchGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :foreman_patch_groups do |t|
      t.string  :name
      t.text    :description
      t.integer :default_window_id
      t.integer :max_unavailable

      t.timestamps
    end

    add_index :foreman_patch_groups, :name, unique: true, name: :foreman_patch_groups_name_uq

    add_foreign_key :foreman_patch_groups, :foreman_patch_window_plans, column: :default_window_id, name: :foreman_patch_groups_default_window_id_fk

    create_table :foreman_patch_group_windows do |t|
      t.integer :group_id
      t.integer :window_id

      t.timestamps
    end

    add_foreign_key :foreman_patch_group_windows, :foreman_patch_groups, column: :group_id, name: :foreman_patch_group_windows_group_id_fk
    add_foreign_key :foreman_patch_group_windows, :foreman_patch_windows, column: :window_id, name: :foreman_patch_group_windows_window_id_fk

    create_table :foreman_patch_group_facets do |t|
      t.integer :host_id
      t.integer :group_id
      t.timestamp :last_patched_at
    end

    add_foreign_key :foreman_patch_group_facets, :hosts, column: :host_id, name: :foreman_patch_group_facets_host_id_fk
    add_foreign_key :foreman_patch_group_facets, :foreman_patch_groups, column: :group_id, name: :foreman_patch_group_facets_group_id_fk
  end
end
