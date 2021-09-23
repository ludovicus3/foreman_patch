object @plan

extends 'foreman_patch/api/v2/plans/base'

child window_plans: :window_plans do
  extends 'foreman_patch/api/v2/window_plans/base'
end

attributes :created_at, :updated_at
