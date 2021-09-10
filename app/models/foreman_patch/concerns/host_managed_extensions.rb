module ForemanPatch
  module Concerns
    module HostManagedExtensions
      extend ActiveSupport::Concern

      included do
        has_many  :invocations, class_name: 'ForemanPatch::Invocation', foreign_key: :host_id
        has_many  :rounds, class_name: 'ForemanPatch::Round', through: :invocations

        scoped_search relation: :rounds, on: :id, complete_value: false, rename: :patch_group_id
      end

    end
  end
end

