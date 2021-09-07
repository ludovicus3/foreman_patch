class CyclePlanStartCorrection < ActiveRecord::Migration[6.0]
  def change
    add_column(:foreman_patch_cycle_plans, :correction, :string)
  end
end
