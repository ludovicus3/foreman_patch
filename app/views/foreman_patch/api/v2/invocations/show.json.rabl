object @invocation

extends 'foreman_patch/api/v2/invocations/base'

child phases: :phases do
  extends 'foreman_patch/api/v2/invocations/phase'
end
