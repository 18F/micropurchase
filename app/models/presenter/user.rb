module Presenter
  class User < SimpleDelegator
    def github_json_url
      "https://api.github.com/user/#{github_id}"
    end
  end
end
