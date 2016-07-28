require 'sinatra/base'

class FakeGitHubApi < Sinatra::Base
  INVALID_API_KEY = "invalidKey5678ijklmnop".freeze
  VALID_API_KEY = "validKeyAbcdfgh123".freeze
  DELETED_USER_ID = '1'
  NO_NAME_USER_ID = '2'

  get '/user/:id' do
    if params[:id] == DELETED_USER_ID
      json_response 404, 'deleted_github_user.json'
    elsif params[:id] == NO_NAME_USER_ID
      json_response 200, 'no_name_github_user.json'
    else
      json_response 200, 'github_user.json'
    end
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
