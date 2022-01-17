class RemoveCycleDescription < ActiveRecord::Migration[6.0]
  def change
    remove_column :foreman_patch_cycles, :description
  end
end
