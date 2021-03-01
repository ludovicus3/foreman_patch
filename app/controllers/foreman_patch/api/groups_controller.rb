module ForemanPatch
  module Api
    class GroupsController < ApiController

      resource_description do
        resource_id 'patch_groups'
        api_version 'v2'
        api_base_url '/foreman_patch/api'
      end

      before_action :find_group, only: [:update, :show, :destroy]

      api :GET, '/groups', N_('List groups')
      param_group :search_and_pagination, ::Api::V2::BaseController
      add_scoped_search_description_for(ForemanPatch::Group)
      def index
        @groups = resource_scope_for_index
      end

      api :GET, '/groups/:id', 'Show group details'
      param :id, :identifier, desc: 'Id of the group', required: true
      def show
      end

      def_param_group :group do
        param :group, Hash, required: true, action_aware: true do
          param :name, String, desc: N_('Name of the patch group'), required: true
          param :description, String, desc: N_('Description of the patch group')
          param :default_window_plan_id, Integer, desc: N_('ID of the default window plan')
          param :max_unavailable, Integer, desc: N_('Maximum number of hosts that can be patched at a time')
          param :default_priority, Integer, desc: N_('Default priority of group within its window (Lowest goes first)')
          param :template_id, Integer, desc: N_('ID of the template used for patching')
        end
      end

      api :POST, '/groups', N_('Create a new patch group')
      param_group :group, as: :create
      def create
        @group = Group.new(group_params)
        @group.save!
      end

      api :PUT, '/groups/:id', N_('Update a patch group')
      param :id, Integer, desc: N_('ID of the group'), required: true
      param_group :group
      def update
        @group.update!(group_params)
      end

      api :DELETE, '/groups/:id', N_('Destroy a patch group')
      param :id, Integer, desc: N_('ID of the group'), required: true
      def destroy
        @group.destroy!
      end

      private

      def find_group
        @group = ForemanPatch::Group.find(params[:id])
      end

      def group_params
        params.require(:group).permit(:name, :description, :default_window_plan_id, :max_unavailable, :default_priority, :template_id)
      end
    end
  end
end

