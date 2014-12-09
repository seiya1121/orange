Rails.application.routes.draw do
  resources :schedules do
    get 'pager', on: :collection
  end

  resources :organizations

  root to: 'top#index'

  # For OmniAuth
  get "/auth/:provider/callback" => "sessions#callback"
  get "/auth/failure"            => "sessions#failure"
  get "/logout"                  => "sessions#destroy", as: :logout
end
