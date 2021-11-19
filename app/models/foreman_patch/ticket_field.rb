module ForemanPatch
  class TicketField < LookupKey

    def ticket?
      true
    end

    def self.humanized_class_name(options = nil)
    end

    def path
      path = self[:path]
      path.presence || array2path(['name', 'cycle'])
    end

    def path=(value)
      return unless value
      using_default = value.tr("\r", "") == array2path(['name', 'cycle'])
      self[:path] = using_default ? nil : value
    end

  end
end
