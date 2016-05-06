class Bid < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :auction
  belongs_to :bidder, class_name: 'User'

  def time
    DcTimePresenter.convert_and_format(created_at)
  end

  def veiled_bidder_attribute(attribute, show_user = nil, message: nil)
    if auction.available? && bidder != show_user
      message
    else
      bidder.send(attribute) || null
    end
  end

  def amount_to_currency_with_asterisk
    return "#{amount_to_currency} *" if winning?
    amount_to_currency
  end

  def veiled_bidder(show_user = nil, message: nil)
    if auction.available? && bidder != show_user
      VeiledBidderPresenter.new(message: message)
    else
      bidder
    end
  end

  def winning_status
    if !auction.show_bids?
      return 'n/a'
    else
      winning?
    end
  end

  private

  def winning?
    self == auction.winning_bid
  end

  def amount_to_currency
    number_to_currency(amount)
  end
end
