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
    client = Octokit::Client.new
    client.user(user.github_id)
  rescue Octokit::Error
    {}
  end

  def client
    @client ||= Octokit::Client.new
  end
end
