namespace :github do
  task fetch: :environment do
    Decorator::GithubInfo.missing.each do |user|
      puts user.name
      user.save
    end
  end
end
