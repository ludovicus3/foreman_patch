module ForemanPatch
  class Override < ::ApplicationRecord
    
    belongs_to :source, class_name: 'ForemanPatch::Invocation', inverse_of: :override
    belongs_to :target, class_name: 'ForemanPatch::Invocation', inverse_of: :original

    belongs_to :user, class_name: 'User'

    def retried?
      target and source.round_id == target.round_id
    end

    def moved?
      target and source.round_id != target.round_id
    end

    def cancelled?
      target.nil?
    end

  end
end
