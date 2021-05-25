class ExpandWindowGroups < ActiveRecord::Migration[6.0]
  class DefaultGroup < ActiveRecord::Base
    self.table_name = 'foreman_patch_groups'
  end

  class Group < ActiveRecord::Base
    self.table_name = 'foreman_patch_window_groups'

    belongs_to :group, class_name: 'DefaultGroup'
  end

  def change
    add_column :foreman_patch_window_groups, :name, :string
    add_column :foreman_patch_window_groups, :description, :text
    add_column :foreman_patch_window_groups, :max_unavailable, :integer

    Group.all.each do |group|
      group.name = group.group.name
      group.description = group.group.description
      group.max_unavailable = group.group.max_unavailable
      group.save!
    end

    change_column_null(:foreman_patch_window_groups, :group_id, true)
    change_column_null(:foreman_patch_window_groups, :name, false)
  end
end
