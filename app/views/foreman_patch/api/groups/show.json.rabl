object @group if @group

extends 'foreman_patch/api/groups/base'

child default_window_plan: :default_window_plan do
  extends 'foreman_patch/api/window_plans/base'
end

attributes :created_at, :updated_at

