module ForemanPatch
  module Ticket
    class FieldRender < ParameterSafeRender
      def initialize(window)
        @window = window
      end

      private

      attr_reader :window

      def render_string(string)
        return string unless string.contains_erb?

        source = Foreman::Renderer::Source::String.new(content: string)
        scope = Foreman::Renderer::get_scope(klass: Foreman::Renderer::Scope::Partition, variables: { window: window })
        Foreman::Renderer.render(source, scope)
      end
    end
  end
end
