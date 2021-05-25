module ForemanPatch
  module Api
    module V2
      class WindowsController < ApiController

        resource_description do
          resource_id 'patch_windows'
          api_version 'v2'
          api_base_url '/foreman_patch/api'
        end

        before_action :find_window, only: [:show, :update, :destroy]

        api :GET, '/windows', N_('List windows')
        api :GET, '/cycles/:cycle_id/windows', N_('List windows from cycle')
        param :cycle_id, Integer, desc: N_('ID of the cycle')
        param_group :search_and_pagination, ::Api::V2::BaseController
        add_scoped_search_description_for(ForemanPatch::Window)
        def index
          @windows = resource_scope_for_index
        end

        api :GET, '/windows/:id', 'Show window details'
        param :id, Integer, desc: N_('ID of the window'), required: true
        def show
        end

        def_param_group :window do
          param :window, Hash, required: true, action_aware: true do
            param :name, String, desc: N_('Name of the patch window'), required: true
            param :description, String, desc: N_('Description of the patch window')
            param :window_plan_id, Integer, desc: N_('ID of the window plan to execute')
            param :start_at, Time, desc: N_('Start time of the patch window'), required: true
            param :end_by, Time, desc: N_('End time of the patch window'), required: true
          end
        end

        api :POST, '/cycles/:cycle_id/windows', N_('Create a new patch window')
        param :cycle_id, Integer, N_('ID of the patch cycle'), required: true
        param_group :window, as: :create
        def create
          @window = Window.new(window_params)
          @window.save!
        end

        api :PUT, '/windows/:id', N_('Update a window')
        param :id, Integer, desc: N_('ID of the window')
        param_group :window
        def update
          @window.update!(window_params)
        end

        api :DELETE, '/windows/:id', N_('Destroy a window')
        param :id, Integer, desc: N_('ID of the window')
        def destroy
          @window.destroy!
        end

        api :POST, '/windows/:id/schedule', N_('Schedule a window')
        param :id, Integer, desc: N_('ID of the window')
        def schedule
          ::ForemanTasks.delay(::Actions::ForemanPatch::Window::Patch, delay_options, @window)
        end

        private

        def allow_nested_id
          %w(cycle_id)
        end

        def delay_options
          {
            start_at: @window.start_at.utc,
            end_by: @window.end_by.try(:utc)
          }
        end

        def find_window
          @window ||= Window.find(params[:id])
        end

        def window_params
          params[:window][:cycle_id] = params[:cycle_id] unless params[:cycle_id].nil?
          params.require(:window).permit(:name, :description, :start_at, :end_by, :cycle_id, :window_plan_id)
        end

      end
    end
  end
end
