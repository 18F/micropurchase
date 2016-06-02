require 'sinatra/base'

class FakeSamApi < Sinatra::Base
  VALID_DUNS = '0123456780000'
  INVALID_DUNS = '0876543210000'
  SMALL_BUSINESS_DUNS = '0123456780001'
  BIG_BUSINESS_DUNS = '0123456780002'

  get '/sam/v4/registrations/:duns' do
    case params[:duns]
    when VALID_DUNS
      json_response 200, 'valid_duns.json'
    when INVALID_DUNS
      json_response 404, 'invalid_duns.json'
    when SMALL_BUSINESS_DUNS
      json_response 200, 'small_business_duns.json'
    when BIG_BUSINESS_DUNS
      json_response 200, 'big_business_duns.json'
    else
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
