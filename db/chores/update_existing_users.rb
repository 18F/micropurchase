class UpdateExistingUsers
  def perform
    User.where(github_login: nil).where.not(github_id: nil).each do |user|
      user_data = parsed_json(user)
      user.github_login = user_data["login"]
      user.email = user_data["email"]
      user.name = user_data["name"]
      user.save(validate: false)
    end
  end

  private

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
