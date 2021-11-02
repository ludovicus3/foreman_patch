module ForemanPatch
  module Parameters
    module TicketField
      extend ActiveSupport::Concern
      include Foreman::Controller::Parameters::LookupKey

      class_methods do
        def ticket_field_params_filter
          Foreman::ParameterFilter.new(ForemanPatch::TicketField).tap do |filter|
            filter.permit_by_context :required, nested: true
            filter.permit_by_context :id, ui: false, api: false, nested: true

            add_lookup_key_params_filter(filter)
          end
        end
      end

      def ticket_field_params
        self.class.ticket_field_params_filter.filter_params(
          params,
          parameter_filter_context
        )
      end
    end
  end
end
