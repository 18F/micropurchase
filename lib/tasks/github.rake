namespace :github do
  task fetch: :environment do
    GithubReckoner.unreckoned.each do |user|
      puts user.name
      GithubReckoner.new(user).set
      user.save!
    end
  end
end
