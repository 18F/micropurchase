class Admin::OpenListItem < Admin::BaseViewModel
  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def title
    auction.title
  end

  def id
    auction.id
  end

  def ended_at
    DcTimePresenter.convert_and_format(auction.ended_at)
  end

  def bid_count
    if bids?
      auction.bids.count
    else
      not_applicable_label
    end
  end

  def lowest_bid_amount
    if bids?
      Currency.new(auction.lowest_bid.amount).to_s
    else
      not_applicable_label
    end
  end

  def current_winner
    if bids?
      lowest_bidder_name
    else
      not_applicable_label
    end
  end

  private

  def not_applicable_label
    I18n.t('needs_attention.index.labels.not_applicable')
  end

  def bids?
    auction.bids.any?
  end

  def lowest_bid
    auction.lowest_bid
  end

  def lowest_bidder_name
    bidder = lowest_bid.bidder
    bidder.name.blank? ? bidder.github_login : bidder.name
  end
end
