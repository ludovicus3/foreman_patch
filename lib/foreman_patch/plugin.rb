Foreman::Plugin.register :foreman_patch do
  requires_foreman '>= 3.0.0'

  apipie_documented_controllers(["#{ForemanPatch::Engine.root}/app/controllers/foreman_patch/api/v2/*.rb"])

  register_facet ForemanPatch::Host::GroupFacet, :group_facet do
    api_view list: 'foreman_patch/api/v2/group_facet/base_with_root', single: 'foreman_patch/api/v2/group_facet/show'
    api_docs :group_facet_attributes, ::ForemanPatch::Api::V2::HostGroupsController
    extend_model ForemanPatch::Concerns::GroupFacetHostExtensions
    set_dependent_action :destroy
  end

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

  RemoteExecutionFeature.register(:power_action, N_("Power Action"), description: N_("Power Action"), provided_inputs: ['action'])
  RemoteExecutionFeature.register(:ensure_services, N_("Ensure Services"), description: N_("Ensure Services are running"))
end
