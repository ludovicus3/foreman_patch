Foreman::Application.routes.draw do
  namespace :foreman_patch do

    namespace :api do
      resources :groups, only: [:index, :show] do
      end

      resources :cycle_plans, only: [:index, :show, :create, :update, :destroy] do
        resources :window_plans, only: [:index, :create]
      end

      resources :window_plans, only: [:index, :show, :update, :destroy] do
      end
    end
  end
end
