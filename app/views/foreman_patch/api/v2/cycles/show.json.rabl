object @cycle

extends 'foreman_patch/api/v2/cycles/base'

child windows: :windows do
  extends 'foreman_patch/api/v2/windows/base'
end

attributes :created_at, :updated_at
