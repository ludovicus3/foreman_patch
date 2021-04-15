class CreateInvocation < ActiveRecord::Migration[6.0]
  def change
    create_table :foreman_patch_invocations do |t|
      t.integer :host_id
      t.integer :window_group_id, null: false
      t.uuid :task_id
    end

    add_index :foreman_patch_invocations, :host_id, name: :foreman_patch_invocations_host_id
    add_index :foreman_patch_invocations, :window_group_id, name: :foreman_patch_invocations_group_invocation_id
    add_index :foreman_patch_invocations, :task_id, name: :foreman_patch_invocations_task_id

    add_foreign_key :foreman_patch_invocations, :hosts, column: :host_id, name: :foreman_patch_invocations_host_id_fk
    add_foreign_key :foreman_patch_invocations, :foreman_patch_window_groups, column: :window_group_id, name: :foreman_patch_invocations_window_group_id_fk
  end
end
