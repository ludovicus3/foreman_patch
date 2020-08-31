class CreateForemanPatchTables < ActiveRecord::Migration[4.2]
  def up
    create_table :foreman_patch_plans, force: true do |t|
      t.string  :name, limit: 255, null: false
      t.integer :recurring_logic_id
      t.integer :task_group_id
    end

    create_table :foreman_patch_groups, force: true do |t|
      t.integer :plan_id
      t.string  :name
      t.integer :round
      t.integer :offset
      t.integer :duration
    end

    create_table :foreman_patch_group_facets, force: true do |t|
      t.integer :host_id
      t.integer :group_id
      t.integer :default_round
    end

    create_table :foreman_patch_cycles, force: true do |t|
      t.integer :plan_id
    end

    create_table :foreman_patch_windows, force: true do |t|
      t.integer :cycle_id
      t.integer :group_id
      t.string  :ticket_id
    end

    create_table :foreman_patch_rounds, force: true do |t|
      t.integer :window_id
      t.integer :round
    end

    create_table :foreman_patch_overrides, force: true do |t|
      t.integer :group_facet_id
      t.integer :cycle_id
      t.integer :window_id
      t.integer :round
    end
  end

  def down
    drop_table :foreman_patch_overrides
    drop_table :foreman_patch_rounds
    drop_table :foreman_patch_windows
    drop_table :foreman_patch_cycles
    drop_table :foreman_patch_group_facets
    drop_table :foreman_patch_groups
    drop_table :foreman_patch_plans
  end
end
