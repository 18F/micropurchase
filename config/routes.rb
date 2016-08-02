Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine => "letter_opener"
  end

  # Web requests

  root 'auctions#index'

  get '/auth/:provider/callback', to: 'authentications#create'
  get '/logout', to: 'authentications#destroy'
  get '/faq', to: 'application#faq'
  get '/auctions/rules/sealed-bid', to: 'auctions#sealed_bid_auction_rules'
  get '/auctions/rules/reverse', to: 'auctions#reverse_auction_rules'
  get '/admin/auctions/:id/preview', to: 'admin/auctions#preview', as: 'admin_preview_auction'
  get '/admin', to: 'admin/auctions#index'
  get '/sign_up', to: 'sign_ups#show'
  get '/sign_in', to: 'sign_ins#show'

  namespace :admin do
    resources :auction_reports, only: [:show]
    resources :user_reports, only: [:index]
    resources :drafts, only: [:index]
    resources :proposals, only: [:create]
    resources :users, only: [:show, :edit, :update]

    namespace :auctions do
      get '/closed', to: 'closed#index'
      get '/needs_attention', to: 'needs_attention#index'
    end

    resources :auctions

    scope '/people' do
      resources :admins, only: [:index]
      resources :vendors, only: [:index]
    end

    scope '/settings' do
      resources :customers, only: [:index, :new, :create, :edit, :update]
      resources :skills, only: [:index, :new, :create, :edit, :update]
    end
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

      get 'business_day', to: 'business_days#show'
    end
  end
end
