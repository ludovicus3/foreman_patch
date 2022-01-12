module ForemanPatch
  class RoundsController < ApplicationController

    before_action :find_resource, only: [:move, :chart, :show]

    helper ForemanPatch::PatchingHelper

    def show
    end

    def resource_class
      ForemanPatch::Round
    end

    private

  end
end
