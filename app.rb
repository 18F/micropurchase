require 'bundler/setup'
require 'sinatra/base'

class App < Sinatra::Base
  get '/' do
    erb :index
  end
  
  get '/make-bid' do
    erb :"make-bid"
  end
  
  get '/my-bids' do
    erb :"my-bids"
  end
  
  get '/bid-submitted' do
    erb :"bid-submitted"
  end
end
