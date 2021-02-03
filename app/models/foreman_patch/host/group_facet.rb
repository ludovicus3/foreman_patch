module ForemanPatch
  module Host
    class GroupFacet < ::ApplicationRecord
      self.table_name = 'foreman_patch_group_facets'
      include Facets::Base

      belongs_to :group, class_name: '::ForemanPatch::Group', inverse_of: :group_facets

      validates :host, presence: true, allow_blank: false
    end
  end
end

