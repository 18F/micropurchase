require 'rails_helper'

describe AccountSubnavViewModel do
  describe '#profile_tab_class' do
    it 'should be active when the active_tab is profile' do
      view_model = AccountSubnavViewModel.new(active_tab: :profile, current_user: nil)
      expect(view_model.profile_tab_class).to eq('nav-auction active')
    end

    it 'should not be active otherwise' do
      view_model = AccountSubnavViewModel.new(active_tab: :bids_placed, current_user: nil)
      expect(view_model.profile_tab_class).to eq('nav-auction')
    end
  end

  describe '#bids_tab_class' do
    it 'should be active when the active_tab is bids_placed' do
      view_model = AccountSubnavViewModel.new(active_tab: :bids_placed, current_user: nil)
      expect(view_model.bids_tab_class).to eq('nav-auction active')
    end

    it 'should not be active otherwise' do
      view_model = AccountSubnavViewModel.new(active_tab: :profile, current_user: nil)
      expect(view_model.bids_tab_class).to eq('nav-auction')
    end
  end

  def bids_tab_partial
    it 'should be null if the current_user is an admin' do
      user = create(:admin)
      view_model = AccountSubnavViewModel.new(active_tab: :bids_placed, current_user: user)

      expect(view_model.bids_tab_partial).to eq('components/null')
    end
  end
end
