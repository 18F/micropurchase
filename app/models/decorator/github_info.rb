module Decorator
  class GithubInfo
    def initialize(user)
      @user = user
    end

    def self.missing
      User.where(github_login: [nil, '']).map {|u| new(u) }
    end
    
    def missing?
      @user.github_login.blank?
    end
      
    def fetch
      return unless missing?
      @user.github_login = github_login
    end

    def save
      fetch
      @user.save
    end

    def name
      @user.name
    end
    
    private

    def github_login
      github_response[:login]
    end
    
    def github_response
      if @user_info.nil?
        begin
          client = Octokit::Client.new
          @user_info = client.user(@user.github_id)
        rescue Octokit::Error
          @user_info = {}
        end
      end
      
      @user_info
    end
  end
end
