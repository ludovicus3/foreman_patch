module ForemanPatch
  class Event < ::ApplicationRecord
    belongs_to :invocation, class_name: 'ForemanPatch::Invocation'

    def as_raw_continuous_output
      raw = attibutes
      raw['output_type'] = raw.delete('event_type')
      raw['output'] = raw.delete('event')
      raw['timestamp'] = raw['timestamp'].to_f
      raw
    end
  end
end