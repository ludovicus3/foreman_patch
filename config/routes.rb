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

    resources :groups, only: [:index, :new, :create, :edit, :update, :destroy] do
      collection do
        get 'auto_complete_search'
      end
    end

    resources :cycle_plans, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  resources :hosts, only: [] do
    collection do
      post 'select_multiple_patch_group'
      post 'update_multiple_patch_group'
    end
  end

end
