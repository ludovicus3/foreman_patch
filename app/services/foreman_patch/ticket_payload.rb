module ForemanPatch
  class TicketPayload
    
    attr_reader :window, :raw

    def initialize(window)
      @window = window

      @safe_render = TicketFieldRender.new(window)

      @raw = {}
      TicketField.all.each do |key|
        @raw.update(key.key => calculate_value(key))
      end

    end

    def keys
      TicketField.all.pluck(:key)
    end

    def [](key)
      @raw[key]
    end

    def to_json(*args)
      @raw.compact.to_json(*args)
    end

    private

    def field(key)
      TicketField.find_by(key: key)
    end

    def calculate_value(key)
      value = nil

      if key.merge_overrides
        value = merged_value(key)
      else
        value = unmerged_value(key)
      end

      unless value.nil?
        needs_late_validation = value.contains_erb?
        value = @safe_render.render(value)
        value = type_cast(key, value)
        validate(key, value) if needs_late_validation 
      end
      
      value
    end

    def merged_value(key)
      case key.key_type
      when 'array'
        merged_array(key)
      when 'hash','yaml','json'
        merged_hash(key)
      else
        raise "merging enabled for non-mergable key #{key.key}"
      end
    end

    def merged_array(key)
      values = default_value(key, [])

      lookup_values(key).each do |lookup_value|
        next if lookup_value.omit

        if key.avoid_duplicates
          values |= lookup_value.value
        else
          values += lookup_value.value
        end
      end
      
      values
    end

    def merged_hash
      values = default_value(key, {})

      lookup_values(key).reverse_each do |lookup_value|
        next if lookup_value.omit

        values.deep_merge!(lookup_value.value)
      end

      values
    end

    def unmerged_value(key)
      lookup_value = lookup_values(key).first

      return key.default_value if lookup_value.nil?
      lookup_value.omit ? nil : lookup_value.value
    end

    def validate(key, value)
      lookup_value = key.lookup_values.build(value: value)
      return true if lookup_value.validate_value
      raise "Invalid value '#{value}' of field #{key.id} '#{key.key}'"
    end

    def matches
      @matches ||= TicketField.all.flat_map(&:path_elements).uniq.map do |rule|
        Array.wrap(rule).map do |element|
          "#{element}#{LookupKey::EQ_DELM}#{window.send(element)}"
        end.join(LookupKey::KEY_DELM)
      end
    end

    def lookup_values(key)
      key.lookup_values.where(match: matches).sort_by do |lookup_value|
        key.path.split.index(lookup_value.path)
      end
    end

    def default_value(key, empty_value)
      default = key.merge_default ? key.default_value : nil
      
      default.nil? ? empty_value : default
    end
    
    def type_cast(key, value)
      Foreman::Parameters::Caster.new(key, attribute_name: :default_value, to: key.key_type, value: value).cast
    rescue TypeError
      Rails.logger.warn "Unable to type cast #{value} to #{key.key_type}"
    end

  end
end
