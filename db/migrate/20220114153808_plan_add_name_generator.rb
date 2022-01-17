class PlanAddNameGenerator < ActiveRecord::Migration[6.0]
  def change
    add_column :foreman_patch_plans, :cycle_name, :string
  end
end 
