require 'bundler/setup'
require 'sinatra/base'
require 'omniauth'
require 'omniauth-github'

class App < Sinatra::Base
  enable :sessions
  use OmniAuth::Builder do
    provider :github,
             ENV['MPT_3500_GITHUB_KEY'],
             ENV['MPT_3500_GITHUB_SECRET']
  end

  get '/auth/github/callback' do
    auth = request.env['omniauth.auth']
    puts auth
  end

  get '/login' do
    erb :login
  end

  get '/' do
    erb :index
  end

  get '/make-bid' do
    erb :make_bid
  end

  get '/my-bids' do
    erb :my_bids
  end

  get '/bid-submitted' do
    erb :bid_submitted
  end
end
