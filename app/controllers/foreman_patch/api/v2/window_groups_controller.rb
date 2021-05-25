module ForemanPatch
  module Api
    module V2
      class WindowGroupsController < ApiController

        resource_description do
          resource_id 'patch_window_groups'
          api_version 'v2'
          api_base_url '/foreman_patch/api'
        end

        before_action :find_window, only: [:index]
        before_action :find_resource, only: [:update, :show, :destroy]

        api :GET, '/window_groups', N_('List window_groups')
        api :GET, '/windows/:window_id/window_groups'. N_('List window groups within a given window')
        param :window_id, :identifier
        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(ForemanPatch::WindowGroup)
        def index
          if @window
            @window_groups = @window.window_groups.search_for(*search_options).paginate(paginate_options)
          else
            @window_groups = resource_scope_for_index
          end
        end

        api :GET, '/window_groups/:id', 'Show window_group details'
        param :id, :identifier, desc: 'Id of the window_group', required: true
        def show
        end

        def_param_group :window_group do
          param :window_group, Hash, required: true, action_aware: true do
            param :name, String, desc: N_('Name of the patch window_group'), required: true
            param :description, String, desc: N_('Description of the patch window_group')
            param :window_id, Integer, desc: N_('ID of the window')
            param :group_id, Integer, desc: N_('ID of the Group')
            param :max_unavailable, Integer, desc: N_('Maximum number of hosts that can be patched at a time')
            param :priority, Integer, desc: N_('Default priority of window_group within its window (Lowest goes first)')
          end
        end

        api :POST, '/window_groups', N_('Create a new patch window_group')
        param_group :window_group, as: :create
        def create
          @window_group = WindowGroup.new(window_group_params)
          @window_group.save!
        end

        api :PUT, '/window_groups/:id', N_('Update a patch window_group')
        param :id, Integer, desc: N_('ID of the window_group'), required: true
        param_group :window_group
        def update
          @window_group.update!(window_group_params)
        end

        api :DELETE, '/window_groups/:id', N_('Destroy a patch window_group')
        param :id, Integer, desc: N_('ID of the window_group'), required: true
        def destroy
          @window_group.destroy!
        end

        def resource_class
          ForemanPatch::WindowGroup
        end

        private

        def find_window
          @window ||= ForemanPatch::Window.find(params[:window_id])
        end

        def window_group_params
          params.require(:window_group).permit(:name, :description, :window_id, :group_id, :max_unavailable, :priority)
        end
      end
    end
  end
end

