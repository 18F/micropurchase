Rails.application.routes.draw do
  root 'auctions#index'

  resources :auctions, only: [:index, :show] do
    resources :bids, only: [:new, :create]
  end

  resources :bids, only: [:index]
  resources :users, only: [:edit, :update]

  namespace :admin do
    resources :auctions
  end

  get '/auth/:provider/callback', to: 'authentications#create'
  get '/login', to: 'logins#index'
  get '/logout', to: 'authentications#destroy'
end
