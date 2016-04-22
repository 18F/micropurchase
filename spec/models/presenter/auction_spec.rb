require 'rails_helper'

RSpec.describe Presenter::Auction do
  let(:ar_auction) { FactoryGirl.create(:auction) }
  let(:ar_bids_by_amount) { ar_auction.bids.order('amount ASC, created_at ASC') }
  let(:auction) { Presenter::Auction.new(ar_auction) }
  let(:user) { FactoryGirl.create(:user) }

  describe 'type-specific bid methods' do
    context 'for a single-bid auction' do
      context 'when the auction is still running' do
        let(:ar_auction) { FactoryGirl.create(:auction, :single_bid_with_tie, :running) }

        context 'when the user has not placed a bid' do
          it 'veiled_bids should return an empty array' do
            expect(auction.veiled_bids(user)).to match_array([])
          end
        end

        context 'the user has placed a bid' do
          let(:last_bid) { auction.bids.last }
          let(:last_bidder) { last_bid.bidder }

          it 'veiled_bids should return only the bid placed by the user' do
            expect(auction.veiled_bids(last_bidder).map(&:id)).to match_array([last_bid].map(&:id))
          end
        end

        context 'when the auction has no bids' do
          it 'veiled_bids should return an empty array' do
            expect(auction.veiled_bids(user)).to match_array([])
          end
        end

        context 'when the auction is closed' do
          let(:ar_auction) { FactoryGirl.create(:auction, :single_bid_with_tie, :closed) }

          it 'veiled_bids should return all bids associated with the auction' do
            expect(auction.veiled_bids(user).map(&:id)).to match_array(auction.bids.map(&:id))
          end
        end

        context 'for a regular auction' do
          context 'when the auction is still running' do
            context 'when the auction has no bids' do
              let(:ar_auction) { FactoryGirl.create(:auction) }

              it 'veiled_bids should return an empty array' do
                expect(auction.veiled_bids(user)).to eq([])
              end
            end
            context 'when the auction has bids' do
              let(:ar_auction) { FactoryGirl.create(:auction, :multi_bid, :with_bidders, :running) }
              let(:ar_lowest_bid) { ar_bids_by_amount.first }
              let(:user) { auction.bids.first.bidder }

              it 'veiled_bids should return all bids' do
                expect(auction.veiled_bids(user)).to eq(auction.bids)
              end
            end
          end
        end
      end

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
  end
end
