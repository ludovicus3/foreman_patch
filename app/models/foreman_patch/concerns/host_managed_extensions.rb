module ForemanPatch
  module Concerns
    module HostManagedExtensions
      extend ActiveSupport::Concern

      included do
        has_many  :invocations, class_name: 'ForemanPatch::Invocation', foreign_key: :host_id
        has_many  :window_groups, class_name: 'ForemanPatch::WindowGroup', through: :invocations

        scoped_search relation: :window_groups, on: :id, complete_value: false, rename: :patch_group_id
      end

    end
  end
end

