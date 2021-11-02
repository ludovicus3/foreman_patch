module ForemanPatch
  class TicketFieldsController < ::LookupKeysController
    include Foreman::Controller::AutoCompleteSearch
    include ForemanPatch::Parameters::TicketField

    before_action :find_resource, only: [:edit, :update, :destroy], if: proc { params[:id] }

    def index
      @ticket_fields = resource_base_search_and_page
    end
    
    def new
      @ticket_field = TicketField.new
    end

    def create
      @ticket_field = TicketField.new(ticket_field_params)
      if @ticket_field.save
        process_success
      else
        process_error
      end
    end

    def resource_class
      ForemanPatch::TicketField
    end

    def resource
      @ticket_field
    end

    def resource_params
      ticket_field_params
    end
  end
end
