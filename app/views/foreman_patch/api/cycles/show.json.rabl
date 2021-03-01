object @cycle

extends 'foreman_patch/api/cycles/base'

child windows: :windows do
  extends 'foreman_patch/api/windows/base'
end

attributes :created_at, :updated_at
