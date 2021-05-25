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

Foreman::Application.routes.draw do
  mount ForemanPatch::Engine, at: '/foreman_patch'

  resources :hosts, only: [] do
    collection do
      post 'select_multiple_patch_group'
      post 'update_multiple_patch_group'
    end
  end
end
