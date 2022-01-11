object @invocation

attributes :id, :round_id, :task_id, :host_id, :state, :result

node(:name) { |inv| inv.host.name }

