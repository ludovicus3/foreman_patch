object @group if @group

extends 'foreman_patch/api/groups/base'

node :default_window_plan do |group|
  partial 'foreman_patch/api/window_plans/base', object: group.default_window_plan
end

attributes :created_at, :updated_at

