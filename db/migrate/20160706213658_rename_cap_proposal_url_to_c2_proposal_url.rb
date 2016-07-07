class RenameCapProposalUrlToC2ProposalUrl < ActiveRecord::Migration
  def change
    rename_column :auctions, :cap_proposal_url, :c2_proposal_url
  end
end
