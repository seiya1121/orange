Rails.application.routes.draw do
  resources :organizations, only: [:index, :create, :update, :edit] do
    resources :groups, only: [:index, :create, :update, :edit]
    resources :schedules do
      get 'pager', on: :collection
    end

    member do
      get 'members'
      get 'add_member'
      delete 'delete_member'
    end
  end

  root to: 'top#index'

  # For OmniAuth
  get "/auth/:provider/callback" => "sessions#callback"
  get "/auth/failure"            => "sessions#failure"
  get "/logout"                  => "sessions#destroy", as: :logout
end
