object @window_plan if @window_plan

extends 'foreman_patch/api/v2/window_plans/base'

child plan: :plan do
  attributes :id, :name
end

child groups: :groups do
  extends 'foreman_patch/api/v2/groups/base'
end

attributes :created_at, :updated_at

