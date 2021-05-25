attributes :id
attributes :group_id

child group: :group do
  attributes :id, :name
end

