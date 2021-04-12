Foreman::Application.routes.draw do
  namespace :foreman_patch do

    namespace :api do
      resources :cycle_plans, only: [:index, :show, :create, :update, :destroy] do
        resources :window_plans, only: [:index, :create]
        resources :cycles, only: [:index, :create]
      end

      resources :window_plans, only: [:index, :show, :update, :destroy]

      resources :cycles, only: [:index, :create, :show, :update, :destroy] do
        resources :windows, only: [:index, :create]
      end

      resources :windows, only: [:index, :show, :update, :destroy] do
        member do
          post :schedule
        end
      end

      resources :groups, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
