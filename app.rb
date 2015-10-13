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

  helpers do
    # define a current_user method, so we can be sure if an user is authenticated
    def current_user
      !session[:uid].nil?
    end
  end

  before do
    # we do not want to redirect to twitter when the path info starts
    # with /auth/
    pass if request.path_info =~ /^\/auth\//

    # /auth/twitter is captured by omniauth:
    # when the path info matches /auth/twitter, omniauth will redirect to twitter
    redirect to('/auth/github') unless current_user
  end

  get '/auth/github/callback' do
    session[:uid] = env['omniauth.auth']['uid']
    # this is the main endpoint to your application
    redirect to('/')
  end

  get '/auth/failure' do
  # omniauth redirects to /auth/failure when it encounters a problem
  # so you can implement this as you please
  end

  get '/logout' do
    session[:uid] = nil
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
