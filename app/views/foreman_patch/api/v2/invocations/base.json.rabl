object @invocation

attributes :id, :window_group_id, :task_id, :host_id

node(:host_name) { |inv| inv.host.name }

