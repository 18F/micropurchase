Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine => "letter_opener"
  end

  # Web requests
  root 'auctions#index'

  get '/auth/:provider/callback', to: 'authentications#create'
  get '/login', to: 'logins#index'
  get '/logout', to: 'authentications#destroy'
  get '/faq', to: 'logins#faq'
  get '/auctions/rules/sealed-bid', to: 'auctions#sealed_bid_auction_rules'
  get '/auctions/rules/reverse', to: 'auctions#reverse_auction_rules'
  get '/admin/auctions/:id/preview', to: 'admin/auctions#preview', as: 'admin_preview_auction'
  get '/admin', to: 'admin/auctions#index'

  namespace :admin do
    resources :auctions
    resources :users, only: [:index, :show, :edit, :update]
    resources :customers
    resources :auction_reports, only: [:show]
    resources :user_reports, only: [:index]
    resources :action_items, only: [:index]
    resources :drafts, only: [:index]
    resources :proposals, only: [:create]
  end

  # Temporarily send JSON requests to web to API
  match '*path.:format', to: redirect("/api/v0/%{path}"), via: [:get, :post], constraints: { format: :json }

  resources :auctions, only: [:index]

  resources :auctions, only: [:show] do
    resources :bid_confirmations, only: [:create]
    resources :bids, only: [:create]
  end

  resources :bids, only: [:index]
  resources :users, only: [:update]
  get 'profile', to: 'users#edit'

  resources :insights, only: [:index]

  # Map current API requests to new controller for now
  namespace :api, defaults: { format: 'json' } do
    namespace :v0 do
      resources :auctions, only: [:index, :show] do
        resources :bids, only: [:create]
      end

      namespace :admin do
        resources :auctions, only: [:index, :show]
        resources :users, only: [:index]
      end
    end
  end
end
