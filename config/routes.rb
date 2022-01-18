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
    end

    resources :invocations, only: [:show, :destroy] do
      collection do
        get 'auto_complete_search'
      end
    end

    resources :plans, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
      resources :window_plans, only: [:new, :create]
      member do
        post :iterate
      end
    end

    resources :window_plans, only: [:edit, :update, :destroy]

    resources :ticket_fields, except: [:show] do
      resources :lookup_values, only: [:index, :create, :update, :destroy]
      collection do
        get 'auto_complete_search'
      end
    end
  end
end
