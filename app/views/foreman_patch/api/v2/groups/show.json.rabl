object @group if @group

extends 'foreman_patch/api/v2/groups/base'

child default_window_plan: :default_window_plan do
  extends 'foreman_patch/api/v2/window_plans/base'
end

child template: :template do
  extends 'api/v2/job_templates/base'
end

attributes :created_at, :updated_at

