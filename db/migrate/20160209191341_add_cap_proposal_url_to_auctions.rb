class AddCapProposalUrlToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :cap_proposal_url, :string
  end
end
