Rails.application.routes.draw do
  root 'auctions#index'

  resources :auctions, only: [:index] do
    resources :bids, only: [:new, :create]
  end

  resources :bids, only: [:index]
  resources :users, only: [:edit, :update]

  get '/auth/:provider/callback', to: 'authentications#create'
  get '/login', to: 'logins#index'
  get '/logout', to: 'authentications#destroy'
end
