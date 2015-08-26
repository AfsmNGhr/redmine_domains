RedmineApp::Application.routes.draw do
  resources :domains do
    get 'context_menu'
    member do
      get 'hide_or_show'
    end
  end
end
