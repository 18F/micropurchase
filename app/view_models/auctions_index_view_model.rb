class AuctionsIndexViewModel
  def initialize(user:, auctions:)
    @user = user
    @auctions = auctions
  end

  def active_auction_count
    auctions
      .where('start_datetime < ?', Time.current)
      .where('end_datetime > ?', Time.current)
      .count
  end

  def upcoming_auction_count
    auctions.where('start_datetime > ?', Time.current).count
  end

  def header_partial
    if user && user.sam_accepted?
      '/components/sam_verified_header'
    elsif user
      '/components/no_sam_verification_header'
    else
      '/components/no_current_user_header'
    end
  end

  def auctions_list_partial
    if auctions.empty?
      'empty_auctions'
    else
      'auctions_list'
    end
  end

  def auctions_list_previous_partial
    if auctions.empty?
      'empty_auctions'
    else
      'auctions_list_previous'
    end
  end

  private

  attr_reader :auctions, :user
end
