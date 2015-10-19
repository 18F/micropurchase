require 'bundler/setup'
require 'sinatra/base'
require 'omniauth'
require 'omniauth-github'
require 'sinatra/activerecord'
require 'json'

require_relative 'models/auction'
require_relative 'models/bid'
require_relative 'models/bidder'

class App < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :database_file, 'database.yml'
  enable :sessions

  puts 'rack env'
  puts ENV['RACK_ENV']

  configure :test do
    ActiveRecord::Base.logger = Logger.new(
      File.new(File.dirname(__FILE__) + '/log/test.log', 'w')
    )
  end

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

  # -------
  # RESTful routes auction bids
  #
  get '/auctions/:auction_id/bids/new' do
    # get the auction
    # get the current bid amount
    # render some stuff, or return json and let the front end do it?
    erb :auctions_bids_new
  end

  post '/auctions/:auction_id/bids' do
    # find the auction
    # create a new bid for the current bidder
    # render some confirmation
    erb :auctions_bids_created
  end

  # RESTful routes bids un-nested from auction and scoped to current user
  get '/bids' do
    # get all my bids
    erb :bids_index
  end
end
