object @override

extends 'foreman_patch/api/v2/overrides/base'

child :source do
  extends 'foreman_patch/api/v2/invocations/base'
end

child :target do
  extends 'foreman_patch/api/v2/invocations/base'
end

child :user do
  extends 'api/v2/users/base'
end

attributes :created_at, :updated_at
