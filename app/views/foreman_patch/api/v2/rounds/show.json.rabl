object @round

extends 'foreman_patch/api/v2/rounds/base'

child :window do
  extends 'foreman_patch/api/v2/windows/base'
end

child :group do
  extends 'foreman_patch/api/v2/groups/base'
end

child invocations: :invocations do
  extends 'foreman_patch/api/v2/invocations/base'
end

attributes :created_at, :updated_at
