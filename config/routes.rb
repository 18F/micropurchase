Rails.application.routes.draw do
  root 'auctions#index'

  get '/auctions/winners/archive', to: 'auctions#previous_winners_archive'
  get '/auctions/winners', to: 'auctions#previous_winners'

  get '/auctions/rules/single-bid', to: 'auctions#single_bid_rules'
  get '/auctions/rules/multi-bid', to: 'auctions#multi_bid_rules'
  resources :auctions, only: [:index, :show] do
    resources :bids, only: [:new, :create, :index] do
      collection do
        post :confirm
      end
    end
  end

  resources :bids, only: [:index]

  get '/my-bids', to: 'bids#my_bids'

  resources :users, only: [:edit, :update]

  get '/admin', to: 'admin/dashboards#index'
  get '/admin/action_items', to: 'admin/dashboards#action_items'
  get '/admin/drafts', to: 'admin/dashboards#drafts'
  get '/admin/auctions/:id/preview', to: 'admin/auctions#preview', as: 'admin_preview_auction'
  namespace :admin do
    resources :auctions
    resources :users
  end

  get '/auth/:provider/callback', to: 'authentications#create'
  get '/login', to: 'logins#index'
  get '/logout', to: 'authentications#destroy'
  get '/faq', to: 'logins#faq'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine => "letter_opener"
  end
end
