object @group if @group

extends 'foreman_patch/api/groups/base'

child :default_window do |window_plan|
  extends 'foreman_patch/api/window_plans/base'
end

attributes :created_at, :updated_at

