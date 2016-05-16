require 'sinatra/base'

class FakeSamApi < Sinatra::Base
  VALID_DUNS = '0123456780000'
  INVALID_DUNS = '0876543210000'

  get '/sam/v4/registrations/:duns' do
    if params[:duns] == VALID_DUNS
      json_response 200, 'duns_info.json'
    elsif params[:duns] == INVALID_DUNS
      json_response 404, 'invalid_duns.json'
    end
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
