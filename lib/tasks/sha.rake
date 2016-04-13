namespace :git do
  desc "Saves the SHA1 to a local file in public"
  task dump_sha: :environment do
    system("git rev-parse HEAD > #{Rails.root.join('public', 'commit.txt')}")
  end
end
