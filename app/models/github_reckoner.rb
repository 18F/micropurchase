class GithubReckoner < Struct.new(:user)
  def set
    return unless unreckoned?
    user.github_login = github_response[:login]
  end

  def unreckoned?
    user.github_login.blank?
  end

  def self.unreckoned
    User.where(github_login: [nil, ''])
  end

  private

  def github_response
    client.user(user.github_id)
  rescue Octokit::Error
    {}
  end

  def client
    @client ||= Octokit::Client.new(client_id: ENV['MPT_3500_GITHUB_KEY'],
                                    client_secret: ENV['MPT_3500_GITHUB_SECRET'])
  end
end
