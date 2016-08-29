class AdminAuctionStatusPresenter::GuestWithToken < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.c2_presenter.guest_with_token.header')
  end

  def body
    I18n.t('statuses.c2_presenter.guest_with_token.body')
  end

  def action_partial
    'components/null'
  end
end
