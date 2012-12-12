RedmineApp::Application.routes.draw do
  resources :projects do
    resources :custom_reports
  end
end
