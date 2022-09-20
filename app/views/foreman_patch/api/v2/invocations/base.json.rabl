object @invocation

attributes :id, :round_id, :task_id, :host_id, :state, :result, :status

node(:name) { |inv| inv.host.name }

