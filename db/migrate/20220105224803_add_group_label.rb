class AddGroupLabel < ActiveRecord::Migration[6.0]

  class Group < ActiveRecord::Base
    self.table_name = :foreman_patch_groups
  end

  def up
    add_column :foreman_patch_groups, :label, :string

    Group.all.each do |group|
      group.label = group.name.downcase.underscore
      group.save!
    end

    change_column_null :foreman_patch_groups, :label, false 

    add_index :foreman_patch_groups, :label, name: :by_label, unique: true
  end

  def down
    remove_index :foreman_patch_groups, name: :by_label
    remove_column :foreman_patch_groups, :label
  end

end
