ForemanPatch::Engine.routes.draw do
  scope :foreman_patch, path: '/foreman_patch' do
    namespace :api do
      scope '(:apiv)', module: :v2, defaults: { apiv: 'v2' }, apiv: /v1|v2/, constraints: ApiConstraints.new(version: 2, default: true) do
        resources :plans, only: [:index, :show, :create, :update, :destroy] do
          resources :window_plans, only: [:index, :create]
          resources :cycles, only: [:index, :create]
        end

        resources :window_plans, only: [:index, :show, :update, :destroy]

        resources :cycles, only: [:index, :create, :show, :update, :destroy] do
          resources :windows, only: [:index, :create]
        end

        resources :windows, only: [:show, :update, :destroy] do
          resources :rounds, only: [:index]
          member do
            post :schedule
          end
        end

        resources :groups, only: [:index, :show, :create, :update, :destroy]

        resources :rounds, only: [:show, :create, :update, :destroy] do
          resources :invocations, only: [:index]
        end

        resources :invocations, only: [:show]

      end
    end
  end
end
