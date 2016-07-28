require_relative "../../db/chores/update_existing_users"

namespace :db do
  desc "Update users with data from GitHub"
  task update_user_data: :environment do
    UpdateExistingUsers.new.perform
  end
end
