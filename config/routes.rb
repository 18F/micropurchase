Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'auctions#index'

  resources :auctions, only: [:index] do
    resources :bids, only: [:new, :create]
  end

  resources :bids, only: [:index]
  resources :users, only: [:edit, :update]

  get '/auth/:provider/callback', to: 'authentications#create'
  get '/logout', to: 'authentications#destroy'
end
