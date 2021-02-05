module ForemanPatch
  module Api
    class GroupsController < ApiController

      before_action :find_group, only: [:show]

      api :GET, '/groups', N_('List groups')
      param_group :search_and_pagination, ::Api::V2::BaseController
      add_scoped_search_description_for(ForemanPatch::Group)
      def index
        @groups = resource_scope_for_index
      end

      api :GET, '/groups/:id', 'Show group details'
      param :id, :identifier, desc: 'Id of the group'
      def show
      end

      def find_group
        @group = ForemanPatch::Group.find(params[:id])
      end
    end
  end
end

