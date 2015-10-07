require 'bundler/setup'
require 'sinatra/base'

class App < Sinatra::Base
  get '/' do
    erb :index
  end
  
  get '/make-bid' do
    erb :"make-bid"
  end
end
