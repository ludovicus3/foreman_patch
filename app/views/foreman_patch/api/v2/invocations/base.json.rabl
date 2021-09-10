object @invocation

attributes :id, :round_id, :task_id

node(:host_name) { |inv| inv.host.name }

