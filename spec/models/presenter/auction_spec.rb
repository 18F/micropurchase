require 'rails_helper'

RSpec.describe Presenter::Auction do
  let(:ar_auction) { FactoryGirl.create(:auction) }
  let(:auction) { Presenter::Auction.new(ar_auction) }
  let(:user) { FactoryGirl.create(:user) }

  describe "#html_summary" do
    let(:summary) { nil }
    let(:auction) { Presenter::Auction.new(FactoryGirl.build(:auction, summary: summary)) }

    it 'should return an empty string if the summary is blank' do
      expect(auction.html_summary).to be_blank
    end

    context 'bold text' do
      let(:summary) { 'This is **bold** text' }

      it 'should render correctly' do
        expect(auction.html_summary).to match("<strong>bold</strong>")
      end
    end

    context 'italicized text' do
      let(:summary) { 'This is _italic_ text' }

      it 'should render correctly' do
        expect(auction.html_summary).to match('<em>italic</em>')
      end
    end

    context 'autolinks' do
      let(:summary) { 'Please visit http://18f.gov anytime' }

      it 'should render correctly' do
        expect(auction.html_summary).to match('<a href="http://18f.gov">http://18f.gov</a>')
      end
    end

    context 'ignoring underscores in words' do
      let(:summary) { 'This_is_a_test' }

      it 'should not render as italicized' do
        expect(auction.html_summary).to_not match('<em>')
      end
    end

    context 'table rendering' do
      let(:summary) { "First Header|Second Header\n------------- | -------------\nContent Cell  | Content Cell\n" }

      it 'should render a table element' do
        expect(auction.html_summary).to match('<table>')
      end
    end
  end

  describe '#html_description' do
    let(:description) { nil }
    let(:auction) { Presenter::Auction.new(FactoryGirl.build(:auction, description: description)) }

    it 'should return an empty string if the description is blank' do
      expect(auction.html_description).to be_blank
    end

    context 'bold text' do
      let(:description) { 'This is **bold** text' }

      it 'should render correctly' do
        expect(auction.html_description).to match("<strong>bold</strong>")
      end
    end

    context 'italicized text' do
      let(:description) { 'This is _italic_ text' }

      it 'should render correctly' do
        expect(auction.html_description).to match('<em>italic</em>')
      end
    end

    context 'autolinks' do
      let(:description) { 'Please visit http://18f.gov anytime' }

      it 'should render correctly' do
        expect(auction.html_description).to match('<a href="http://18f.gov">http://18f.gov</a>')
      end
    end

    context 'ignoring underscores in words' do
      let(:description) { 'This_is_a_test' }

      it 'should not render as italicized' do
        expect(auction.html_description).to_not match('<em>')
      end
    end

    context 'table rendering' do
      let(:description) { "First Header|Second Header\n------------- | -------------\nContent Cell  | Content Cell\n" }

      it 'should render a table element' do
        expect(auction.html_description).to match('<table>')
      end
    end
  end
end
