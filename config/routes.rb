Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine => "letter_opener"
  end

  # Web requests

  root 'auctions#index'

  get '/auth/github/callback', to: 'authentications#create'
  get '/logout', to: 'authentications#destroy'

  post 'auth/saml/callback', to: 'sessions#create'
  post 'auth/saml/logout', to: 'sessions#destroy'
  delete 'auth/saml/logout', to: 'sessions#destroy'
  match 'auth/saml/setup', to: 'sessions#setup', via: [:get, :post]
  put 'auth/saml/remove', to: 'sessions#remove'

  get '/auctions/rules/sealed-bid', to: 'auctions#sealed_bid_auction_rules'
  get '/auctions/rules/reverse', to: 'auctions#reverse_auction_rules'
  get '/admin', to: 'admin/auctions/needs_attention#index'
  get '/sign_up', to: 'sign_ups#show'
  get '/sign_in', to: 'sign_ins#show'
  get '/sign_in/admin', to: 'sign_ins#show_admin'

  get '/api' => 'docs#index', as: 'api_doc'

  namespace :admin do
    resources :auction_reports, only: [:show]
    resources :auction_rejections, only: [:update]
    resources :auction_acceptances, only: [:update]
    resources :auction_mark_payments, only: [:update]
    resources :missed_deliveries, only: [:update]
    resources :user_reports, only: [:index]
    resources :proposals, only: [:create]
    resources :users, only: [:show, :edit, :update]

    namespace :auctions do
      get '/closed', to: 'closed#index'
      get '/needs_attention', to: 'needs_attention#index'
    end

    resources :auctions, except: [:index]

    scope '/people' do
      resources :admins, only: [:index]
      resources :vendors, only: [:index]
      resources :vendors, only: [:show] do
        resources :masquerades, only: [:new, :destroy]
      end
    end

    scope '/settings' do
      resources :customers, only: [:index, :new, :create, :edit, :update]
      resources :skills, only: [:index, :new, :create, :edit, :update]
    end
  end

  resources :auctions, only: [:index, :update]

  resources :auctions, only: [:show] do
    resources :bids, only: [:create]
    resources :receipts, only: [:new, :create]

    get 'receipt', to: 'receipts#show'
  end

  resources :users, only: [:update]
  get 'account/profile', to: 'users#edit', as: 'profile'
  get 'account/bids', to: 'bids#index', as: 'bids_placed'

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
