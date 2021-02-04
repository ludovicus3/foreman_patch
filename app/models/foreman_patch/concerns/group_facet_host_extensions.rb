module ForemanPatch
  module Concerns
    module GroupFacetHostExtensions
      extend ActiveSupport::Concern

      included do
        has_one :group, through: :group_facet

        scoped_search relation: :group, on: :name, complete_value: true, rename: :patch_group
        scoped_search relation: :group_facet, on: :last_patched_at, complete_value: true, rename: :last_patched

        accepts_nested_attributes_for(
          :group_facet,
          self.nested_attributes_options[:group_facet].merge(
            reject_if: :group_facet_ignore_update?
          )
        )

        def group_facet_ignore_update?(attributes)
          self.group_facet.blank? && (
            attributes.values.all?(&:blank?) ||
            attributes['group_id'].blank?
          )
        end
      end

      module ClassMethods
      end
    end
  end
end

class ::Host::Managed::Jail < Safemode::Jail
  allow :group
end
