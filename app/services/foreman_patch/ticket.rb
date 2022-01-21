module ForemanPatch
  module Ticket

    def self.publish(window)
      change = ChangeRequest.new(window)
      change.save
    end

    def self.get(window)
      ChangeRequest.new(window)
    end

  end
end
