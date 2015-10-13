require 'bundler/setup'
require 'sinatra/base'

class App < Sinatra::Base
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
