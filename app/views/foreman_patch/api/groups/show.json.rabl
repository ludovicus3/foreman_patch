object @group if @group

extends 'foreman_patch/api/groups/base'

child default_window_plan: :default_window_plan do
  extends 'foreman_patch/api/window_plans/base'
end

child template: :template do
  extends 'api/v2/job_templates/base'
end

attributes :created_at, :updated_at

