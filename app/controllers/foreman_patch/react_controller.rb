module ForemanPatch
  class ReactController < ::ApplicationController
    skip_before_action :authorize
    
    include Rails.application.routes.url_helpers
    
    def index
      render 'foreman_patch/layouts/react', layout: false
    end
  end
end

