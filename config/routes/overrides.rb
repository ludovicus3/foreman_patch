Foreman::Application.routes.draw do
  
  resources :hosts, only: [] do
    collection do
      post 'select_multiple_patch_group'
      post 'update_multiple_patch_group'
    end
  end

end
