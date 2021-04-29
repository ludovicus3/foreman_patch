class Setting::Patching < ::Setting
  def self.default_settings
    [
      self.set('host_max_wait_for_up', N_("Maximum seconds to wait for a host to register as up after patching restart."),
               600, N_("Max wait for host up"))
    ]
  end

  def self.humanized_category
    N_('Patching')
  end

  def self.load_defaults
    BLANK_ATTRS.concat %w(host_max_wait_for_up)
    super
  end
end
