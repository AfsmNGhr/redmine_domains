RedmineApp::Application.routes.draw do
  resources :domains do
    collection do
      get :context_menu
    end
    member do
      get :hide_or_show
    end
  end
end
