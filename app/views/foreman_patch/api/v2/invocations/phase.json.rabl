object @phase

attribute :label, :humanized_name, :exit_status

node do |phase|
  { live_output: normalize_line_sets(phase.live_output) }
end