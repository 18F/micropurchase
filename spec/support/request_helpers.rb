module RequestHelpers
  def json_response
    JSON.parse(response.body)
  end

  def login(user = FactoryGirl.create(:user))
    stub_github('/user') do
      github_response_for_user(user)
    end
  end

  def headers(api_key = valid_api_key)
    {
      'HTTP_ACCEPT' => 'text/x-json',
      'HTTP_API_KEY' => api_key
    }
  end

  def valid_api_key
    FakeGitHub::VALID_API_KEY
  end

  def github_request_headers
    {
      'Accept'=>'application/vnd.github.v3+json',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization'=>'token validKeyAbcdfgh123',
      'Content-Type'=>'application/json',
      'User-Agent'=>'Octokit Ruby Gem 4.3.0'
    }
  end

  def handle_request(request, response_body: nil)
    response_headers = { 'Content-Type' => 'application/json' }
    bad_credentials  = "{\"message\":\"Bad Credentials\"}"
    token = request.headers['Authorization'].split[1] rescue nil

    if token != FakeGitHub::VALID_API_KEY
      response_body = bad_credentials
      response_status = 401
    end

    { status: response_status, body: response_body, headers: response_headers }
  end

  def stub_github(path, response_status: 200, &block)
    url                          = "https://api.github.com#{path}"
    request_headers_without_auth = github_request_headers
    request_headers_with_auth    = github_request_headers.merge({'Authorization' => /token ()/})
    default_response_body        = JSON.generate(block.call)

    # stub requests where no Authorization header is set
    WebMock.stub_request(:get, url)
      .with(headers: request_headers_without_auth)
      .to_return {|request| handle_request(request, response_body: default_response_body)}

    # stub requests that include an Authorization header
    WebMock.stub_request(:get, url)
      .with(headers: request_headers_with_auth)
      .to_return {|request| handle_request(request, response_body: default_response_body)}
  end

  def github_response_for_user(user)
    {
      "login": Faker::Internet.user_name,
      "id": user.github_id,
      "avatar_url": "https://github.com/images/error/octocat_happy.gif",
      "gravatar_id": "",
      "url": "https://api.github.com/users/octocat",
      "html_url": "https://github.com/octocat",
      "followers_url": "https://api.github.com/users/octocat/followers",
      "following_url": "https://api.github.com/users/octocat/following{/other_user}",
      "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
      "organizations_url": "https://api.github.com/users/octocat/orgs",
      "repos_url": "https://api.github.com/users/octocat/repos",
      "events_url": "https://api.github.com/users/octocat/events{/privacy}",
      "received_events_url": "https://api.github.com/users/octocat/received_events",
      "type": "User",
      "site_admin": false,
      "name": "monalisa octocat",
      "company": "GitHub",
      "blog": "https://github.com/blog",
      "location": "San Francisco",
      "email": "octocat@github.com",
      "hireable": false,
      "bio": "There once was...",
      "public_repos": 2,
      "public_gists": 1,
      "followers": 20,
      "following": 0,
      "created_at": "2008-01-14T04:33:35Z",
      "updated_at": "2008-01-14T04:33:35Z",
      "total_private_repos": 100,
      "owned_private_repos": 100,
      "private_gists": 81,
      "disk_usage": 10000,
      "collaborators": 8,
      "plan": {
        "name": "Medium",
        "space": 400,
        "private_repos": 20,
        "collaborators": 0
      }
    }
  end
end
