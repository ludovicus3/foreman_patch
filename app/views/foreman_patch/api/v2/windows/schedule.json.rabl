object @window

extends 'foreman_patch/api/v2/windows/base'

child :cycle do
  extends 'foreman_patch/api/v2/cycles/base'
end

child :window_plan do
  extends 'foreman_patch/api/v2/window_plans/base'
end

attributes :created_at, :updated_at
