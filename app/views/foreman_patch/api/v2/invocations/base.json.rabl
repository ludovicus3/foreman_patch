object @invocation

attributes :id, :round_id, :task_id, :host_id, :state, :result

node(:host_name) { |inv| inv.host.name }

