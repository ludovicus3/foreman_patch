Foreman::Plugin.register :foreman_patch do
  requires_foreman '~> 3.1'

  register_global_js_file 'global'

  settings do
    category(:patching, N_('Patching')) do
      setting('host_max_wait_for_up',
        type: :integer,
        description: N_("Maximum seconds to wait for a host after patching restart."),
        default: 600,
        full_name: N_("Max wait for host up"))
      setting('host_patch_timeout',
        type: :integer,
        description: N_("Maximum seconds for a patching invocation to run before timing out"),
        default: nil,
        full_name: N_('Patch Timeout'))
      setting('patch_schedule_time_zone',
        type: :string,
        description: N_('Time zone used to base patch window scheduling off of.'),
        default: 'UTC',
        full_name: N_('Patch Schedule Time Zone'),
        collection: proc { ActiveSupport::TimeZone.all.map { |tz| [ tz.name, tz.name ] }.to_h })
      setting('ticket_api_host',
        type: :string,
        description: N_('Host used for change management tickets'),
        default: nil,
        full_name: N_('Ticket API host'))
      setting('ticket_api_proxy',
        type: :string,
        description: N_('HTTP Proxy to access ticket API host'),
        default: nil,
        full_name: N_('Ticket API HTTP proxy'),
        collection: proc { HttpProxy.all.map { |proxy| [proxy.name, proxy.name_and_url] }.to_h },
        include_blank: N_('no proxy'))
      setting('ticket_api_user',
        type: :string,
        description: N_('User with access to ticket API'),
        default: nil,
        full_name: N_('Ticket API user'))
      setting('ticket_api_password',
        type: :string,
        description: N_('Password for ticket API user'),
        default: nil,
        full_name: N_('Ticket API password'),
        encrypted: true)
      setting('ticket_api_path',
        type: :string,
        description: N_('Ticket API path for REST/CRUD operations'),
        default: nil,
        full_name: N_('Ticket API path'))
      setting('ticket_web_ui_path',
        type: :string,
        description: N_('Path for opening a ticket in the web UI'),
        default: nil,
        full_name: N_('Ticket Web UI path'))
      setting('ticket_label_field',
        type: :string,
        description: N_('Name of the field used for the ticket label'),
        default: nil,
        full_name: N_('Ticket label field'))
      setting('ticket_id_field',
        type: :string,
        description: N_('Name of the field used for the ticket id'),
        default: nil,
        full_name: N_('Ticket ID field'))
      setting('skip_broken_patches',
        type: :boolean,
        description: N_('Skip broken dependencies during patching'),
        default: true,
        full_name: N_('Skip broken patches'))
    end
  end

  apipie_documented_controllers(["#{ForemanPatch::Engine.root}/app/controllers/foreman_patch/api/v2/*.rb"])

  # Add permissions
  security_block :foreman_patch do
  end

  divider :top_menu, caption: N_('Patching'), parent: :content_menu
  menu :top_menu, :groups,
    caption: N_('Groups'),
    engine: ForemanPatch::Engine,
    parent: :content_menu

  menu :top_menu, :cycles,
    caption: N_('Cycles'),
    engine: ForemanPatch::Engine,
    parent: :content_menu

  menu :top_menu, :plans,
    caption: N_('Plans'),
    engine: ForemanPatch::Engine,
    parent: :content_menu

  menu :top_menu, :ticket_fields,
    caption: N_('Ticket Fields'),
    engine: ForemanPatch::Engine,
    parent: :content_menu

  parameter_filter ::Host::Managed, :group_facet_attributes => [:group_id]

  describe_host do
    multiple_actions_provider :patch_host_multiple_actions
    overview_fields_provider :patch_host_overview_fields
  end

  register_facet ForemanPatch::Host::GroupFacet, :group_facet do
    api_view list: 'foreman_patch/api/v2/group_facet/base_with_root',
      single: 'foreman_patch/api/v2/group_facet/show'
    api_docs :group_facet_attributes, ::ForemanPatch::Api::V2::HostGroupsController
    extend_model ForemanPatch::Concerns::GroupFacetHostExtensions
    set_dependent_action :destroy
  end

  RemoteExecutionFeature.register(:power_action, N_("Power Action"), description: N_("Power Action"), provided_inputs: ['action'])
  RemoteExecutionFeature.register(:ensure_services, N_("Ensure Services"), description: N_("Ensure Services are running"))
end
