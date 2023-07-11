class CreateInvocationEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :foreman_patch_events do |t|
      t.bigint :invocation_id, null: false
      t.integer :sequence, null: false
      t.timestamp :timestamp, null: false
      t.string :event_type, null: false
      t.string :event, null: false
      t.string :meta

      t.index [:invocation_id, :sequence], unique: true, name: :foreman_patch_events_index
    end

    add_foreign_key :foreman_patch_events, :foreman_patch_invocations, column: :invocation_id, name: :foreman_patch_events_for_invocation, on_delete: :cascade
  end
end