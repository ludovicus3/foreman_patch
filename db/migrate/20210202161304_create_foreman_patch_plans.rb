class CreateForemanPatchPlans < ActiveRecord::Migration[6.0]
  def change
    create_table :foreman_patch_cycle_plans do |t|
      t.string    :name, null: false
      t.text      :description
      t.timestamp :start_date
      t.integer   :interval
      t.string    :units
      t.integer   :active_count

      t.timestamps
    end

    add_index :foreman_patch_cycle_plans, :name, unique: true, name: :foreman_patch_cycle_plans_name_uq

    create_table :foreman_patch_window_plans do |t|
      t.string  :name, null: false
      t.text    :description
      t.integer :cycle_plan_id, null: false
      t.integer :start_day
      t.time    :start_time
      t.integer :duration

      t.timestamps
    end

    add_index :foreman_patch_window_plans, :name, name: :foreman_patch_window_plans_name_idx
    add_index :foreman_patch_window_plans, [:cycle_plan_id, :name], unique: true, name: :foreman_patch_window_plans_cycle_plan_id_name_uq
    
    add_foreign_key :foreman_patch_window_plans, :foreman_patch_cycle_plans, column: :cycle_plan_id, name: :foreman_patch_window_plans_cycle_plan_id_fk
  end
end
