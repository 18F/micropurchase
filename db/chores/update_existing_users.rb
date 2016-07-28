class UpdateExistingUsers
  attr_reader :users

  def initialize(users = User.where(github_login: nil).where.not(github_id: nil))
    @users = users
  end

  def perform
    users.each do |user|
      user_data = parsed_json(user)
      next if user_data['message']

      user.github_login = user_data['login']
      user.email = user_data['email']
      user.name = name(user_data)
      user.save(validate: false)
    end
  end

  private

  def name(user_data)
    user_data['name'] || ''
  end

  def parsed_json(user)
    JSON.parse(data(user))
  end

  def data(user)
    Net::HTTP.get(URI(url(user)))
  end

  def url(user)
    "https://api.github.com/user/#{user.github_id}"
  end
end
