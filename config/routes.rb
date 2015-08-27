RedmineApp::Application.routes.draw do
  resources :domains, except: :destroy do
    collection do
      get :context_menu
    end
    member do
      get :hide_or_show
    end
  end

  get 'projects/:id/accesses', to: 'accesses#index', as: 'project_accesses'
  resources :accesses, except: :destroy
end
