ForemanPatch::Engine.routes.draw do
  scope :foreman_patch, path: '/foreman_patch' do
    resources :groups, only: [:index, :new, :create, :edit, :update, :destroy] do
      collection do
        get 'auto_complete_search'
      end
    end

    resources :cycles, only: [:index, :show, :destroy] do
      collection do
        get 'auto_complete_search'
      end

      resources :windows, only: [:new, :create]
    end

    resources :windows, only: [:show, :destroy]

    resources :rounds, only: [:show] do
      collection do
        get 'auto_complete_search'
      end
      member do
        get 'chart'
        post 'move'
      end
    end

    resources :invocations, only: [:show]

    resources :cycle_plans, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
      resources :window_plans, only: [:new, :create]
    end

    resources :window_plans, only: [:edit, :update, :destroy]
  end
end
