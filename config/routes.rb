RedmineApp::Application.routes.draw do
  resources :domains do
    member do
      get 'hide_or_show'
    end
  end
end
