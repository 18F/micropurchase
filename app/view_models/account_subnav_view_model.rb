class AccountSubnavViewModel
  attr_reader :active_tab, :current_user

  def initialize(active_tab:, current_user:)
    @active_tab = active_tab
    @current_user = current_user
  end

  def profile_tab_class
    "nav-auction#{' active' if active_tab == :profile}"
  end

  def bids_tab_class
    "nav-auction#{' active' if active_tab == :bids_placed}"
  end

  def bids_tab_partial
    if current_user.decorate.admin?
      'components/null'
    else
      'users/subnav_bids_placed'
    end
  end
end
