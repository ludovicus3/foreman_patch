Foreman::Application.routes.draw do
  namespace :foreman_patch do

    namespace :api do
      resources :groups, only: [:index, :show] do
      end
    end
  end
end
