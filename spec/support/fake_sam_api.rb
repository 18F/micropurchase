require 'sinatra/base'

class FakeSamApi < Sinatra::Base
  VALID_DUNS = '0123456780000'
  INVALID_DUNS = '0876543210000'

  get '/sam/v4/registrations/:duns' do
    if params[:duns] == VALID_DUNS
      status 200
    elsif params[:duns] == INVALID_DUNS
      status 400
    end
  end
end
