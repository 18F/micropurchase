class AuctionFactoryFactory
  def initialize(type)
    @type = type
  end

  def create
    case @type
    when 'unpublished'
      FactoryGirl.create(:auction, :unpublished)
    when 'future'
      FactoryGirl.create(:auction, :future)
    when 'closed'
      FactoryGirl.create(:auction, :closed, :with_bidders)
    when 'closed bidless'
      FactoryGirl.create(:auction, :closed)
    when 'expiring'
      FactoryGirl.create(:auction, :expiring, :with_bidders)
    when 'open bidless'
      FactoryGirl.create(:auction)
    when 'open'
      FactoryGirl.create(:auction, :with_bidders)
    when 'single-bid'
      FactoryGirl.create(:auction, :running, :single_bid)
    when 'closed single-bid'
      FactoryGirl.create(:auction, :closed, :with_bidders, :single_bid)
    when 'needs evaluation'
      FactoryGirl.create(:auction, :with_bidders, :evaluation_needed)
    when 'within simplified acquisition threshold'
      FactoryGirl.create(:auction, :between_micropurchase_and_sat_threshold, :available)
    when 'below the micropurchase threshold'
      FactoryGirl.create(:auction, :below_micropurchase_threshold, :available)
    when 'the winning vendor is not eligible to be paid'
      FactoryGirl.create(:auction,
                         :between_micropurchase_and_sat_threshold,
                         :winning_vendor_is_non_small_business,
                         :evaluation_needed)
    else
      fail "Unrecognized auction type: #{@type}"
    end
  end
end
