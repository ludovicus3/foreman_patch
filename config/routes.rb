ForemanPatch::Engine.routes.draw do
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

  resources :window_groups, only: [:show] do
    collection do
      get 'chart'
    end
    member do
      post 'move'
    end
  end

  resources :invocations, only: [:show]

  resources :cycle_plans, only: [:index, :new, :create, :edit, :update, :destroy]
end
