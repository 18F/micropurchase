require 'bundler/setup'
require 'sinatra/base'
require 'omniauth'
require 'omniauth-github'
require 'sinatra/activerecord'
require 'json'

require_relative 'models/auction'
require_relative 'models/bid'
require_relative 'models/user'
require_relative 'models/authenticator'
require_relative 'models/admins'


class App < Sinatra::Base
  use Rack::MethodOverride
  register Sinatra::ActiveRecordExtension
  set :database_file, 'database.yml'
  enable :sessions

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
    def current_user
      @current_user ||= User.where(id: session[:user_id]).first
    end

    def require_authentication
      redirect to('/auth/github') unless current_user
    end
  end

  get '/auth/github/callback' do
    redirect to(Authenticator.new(env['omniauth.auth'], session).perform)
  end

  get '/auth/failure' do
    # omniauth redirects to /auth/failure when it encounters a problem
    # so you can implement this as you please
  end

  get '/logout' do
    session.clear
  end

  get '/' do
    erb :index
  end

  # -------
  # RESTful routes auction bids
  #
  get '/users/:id/edit' do
    begin
      @user = User.find(params[:id])
      halt(403) if @user.id != session[:user_id]
      erb :users_edit
    rescue ActiveRecord::RecordNotFound
      halt(404)
    end
  end

  put '/users/:id' do
    require_authentication
    begin
      @user = User.find(params[:id])
      halt(403) if @user.id != session[:user_id]
      @user.update_attributes({
        sam_id: params[:sam_id],
        duns_id: params[:duns_id]
      })
      redirect to('/')
    rescue ActiveRecord::RecordNotFound
      halt(404)
    end
  end

  get '/auctions/:auction_id/bids/new' do
    # get the auction
    # get the current bid amount
    # render some stuff, or return json and let the front end do it?
    erb :auctions_bids_new
  end

  post '/auctions/:auction_id/bids' do
    require_authentication
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

  error 403 do
    'Access forbidden'
  end

  error 404 do
    'Record not found'
  end
end
