class AddUserToAuctions < ActiveRecord::Migration
  def change
    add_reference :auctions, :user, index: true
  end
end
