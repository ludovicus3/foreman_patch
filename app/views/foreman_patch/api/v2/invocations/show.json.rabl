object @invocation

extends 'foreman_patch/api/v2/invocations/base'

child events: :events do
  extends 'foreman_patch/api/v2/invocations/event'
end
