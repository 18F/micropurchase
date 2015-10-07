require 'bundler/setup'
require 'sinatra/base'

class App < Sinatra::Base
  get '/' do
    erb :index
  end
end
