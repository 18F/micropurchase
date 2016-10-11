class BiddingStatusPresenter::Base
  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def start_label
    ''
  end

  def deadline_label
    ''
  end

  def relative_time
    ''
  end

  def label_class
    ''
  end

  def label
    ''
  end

  def bid_label(_user)
    ''
  end

  def tag_data_value_status
    ''
  end

  def tag_data_label_2
    ''
  end

  def tag_data_value_2
    ''
  end
end
