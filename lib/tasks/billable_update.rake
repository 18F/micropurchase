require_relative "../../db/chores/update_auctions_billable_data"

namespace :db do
  desc "Update auction billable_to data"
  task update_billable_data: :environment do
    UpdateAuctionsBillableData.new.perform
  end
end
