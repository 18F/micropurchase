require 'sinatra/base'

class FakeC2Api < Sinatra::Base
  PURCHASED_PROPOSAL_ID = '1'.freeze

  post '/oauth/token' do
    json_response 200, 'c2_access_token.json'
  end

  get '/proposals/:id' do
    if params[:id] == PURCHASED_PROPOSAL_ID
      json_response 200, 'c2_proposal_purchased.json'
    else
      json_response 200, 'c2_proposal_not_purchased.json'
    end

  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
