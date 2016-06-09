Rails.application.routes.draw do
  get '/admin', to: 'admin/dashboards#index'
  get '/admin/action_items', to: 'admin/dashboards#action_items'
  get '/admin/drafts', to: 'admin/dashboards#drafts'
  get '/admin/auctions/:id/preview', to: 'admin/auctions#preview', as: 'admin_preview_auction'

  namespace :admin do
    resources :auctions
    resources :users, only: [:index, :edit, :update, :show]
    resources :auction_reports, only: [:show]
    resources :user_reports, only: [:index]
  end

  get '/auth/:provider/callback', to: 'authentications#create'
  get '/login', to: 'logins#index'
  get '/logout', to: 'authentications#destroy'
  get '/faq', to: 'logins#faq'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine => "letter_opener"
  end

  # Web requests
  root 'auctions#index'
  get '/auctions/winners', to: 'auctions#previous_winners'

  get '/auctions/rules/single-bid', to: 'auctions#single_bid_rules'
  get '/auctions/rules/multi-bid', to: 'auctions#multi_bid_rules'

  # Map current API requests to new controller for now
  namespace :api, defaults: { format: 'json' } do
    namespace :v0 do
      resources :auctions, only: [:index, :show] do
        resources :bids, only: [:new, :create, :index] do
          collection do
            post :confirm
          end
        end
      end
    end
  end

  # Temporarily send JSON requests to web to API
  match '*path.:format', to: redirect("/api/v0/%{path}"), via: [:get, :post], constraints: { format: :json }

  resources :auctions, only: [:index, :show] do
    resources :bids, only: [:new, :create, :index] do
      collection do
        post :confirm
      end
    end
  end

  resources :bids, only: [:index]
  get '/my-bids', to: 'bids#my_bids'

  resources :users, only: [:update]
  get 'users/edit' => 'users#edit'
end
