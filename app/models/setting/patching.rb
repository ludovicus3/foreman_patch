module Setting
  class Patching < ::Setting
    def self.default_settings
    end

    def self.humanized_category
      N_('Patching')
    end

    def self.load_defaults
      BLANK_ATTRS.concat %w()
      super
    end
  end
end

