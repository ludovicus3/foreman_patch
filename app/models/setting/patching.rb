class Setting::Patching < ::Setting
  def self.default_settings
    http_proxy_select = [{
      name: _('Http Proxies'),
      class: 'HttpProxy',
      scope: 'all',
      value_method: 'name',
      text_method: 'name_and_url',
    }]

    template_select = [{
      name: _('Ticket Templates'),
      class: 'ReportTemplate',
      scope: 'all',
      value_method: 'id',
      text_method: 'name',
    }]

    # set(name, description, default, fullname, value, { options })
    [
      self.set('host_max_wait_for_up', N_("Maximum seconds to wait for a host after patching restart."),
               600, N_("Max wait for host up")),
      self.set('ticket_template', N_("Default template used for generating ticket."), 
               nil, N_('Ticket Template'), nil, 
               collection: proc { template_select }),
      self.set('ticket_api_host', N_('Host used for change management tickets'),
               nil, N_('Ticket API host')),
      self.set('ticket_api_proxy', N_('HTTP Proxy to access ticket API host'),
               nil, N_('Ticket API HTTP proxy'), nil,
               collection: proc { http_proxy_select }, include_blank: N_('no proxy')),
      self.set('ticket_api_user', N_('User with access to ticket API'),
               nil, N_('Ticket API user')),
      self.set('ticket_api_password', N_('Password for ticket API user'),
               nil, N_('Ticket API password'), nil, { encrypted: true }),
      self.set('ticket_api_get_path', N_('Ticket API path for GET operations'),
               '/api/now/table/change_request/:id', N_('Ticket API GET path')),
      self.set('ticket_api_post_path', N_('Ticket API path for POST operations'),
               '/api/now/table/change_request', N_('Ticket API POST path')),
      self.set('ticket_api_put_path', N_('Ticket API path for PUT operations'),
               '/api/now/table/change_request/:id', N_('Ticket API PUT path')),
      self.set('ticket_web_ui_path', N_('Path for opening a ticket in the web UI'),
               '/change_request.do?sys_id=:id', N_('Ticket Web UI path')),
      self.set('ticket_label_field', N_('Name of the field used for the ticket label'),
               'number', N_('Ticket label field')),
      self.set('ticket_id_field', N_('Name of the field used for the ticket id'),
               'sys_id', N_('Ticket ID field'))
    ]
  end

  def self.humanized_category
    N_('Patching')
  end

  def self.load_defaults
    BLANK_ATTRS.concat %w(ticket_template ticket_api_host ticket_api_proxy ticket_api_user ticket_api_password)
    super
  end
end
