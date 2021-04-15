object @window

extends 'foreman_patch/api/windows/base'

child :cycle do
  extends 'foreman_patch/api/cycles/base'
end

child :window_plan do
  extends 'foreman_patch/api/window_plans/base'
end

attributes :created_at, :updated_at
