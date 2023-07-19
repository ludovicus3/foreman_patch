object @invocation

attributes :id, :round_id, :task_id, :host_id, :status

node(:name) { |inv| inv.host.name }

