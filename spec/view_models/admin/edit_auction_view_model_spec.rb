require 'rails_helper'

describe Admin::EditAuctionViewModel do
  describe '#published_options' do
    context 'auction does not have c2 approval' do
      context 'auction is closed' do
        it 'returns all options' do
          auction = create(:auction, :closed, c2_approval_status: :not_requested)

          view_model = Admin::EditAuctionViewModel.new(auction)

          expect(view_model.published_options).to eq(%w(unpublished published))
        end
      end

      context 'auction is not closed' do
        it 'does not return published option' do
          auction = create(:auction, :future, c2_approval_status: :not_requested)

          view_model = Admin::EditAuctionViewModel.new(auction)

          expect(view_model.published_options).to eq(%w(unpublished))
        end
      end
    end

    context 'auction does have c2_approved_at' do
      it 'returns all options' do
        auction = create(:auction, c2_approval_status: :approved)

        view_model = Admin::EditAuctionViewModel.new(auction)

        expect(view_model.published_options).to eq(%w(unpublished published))
      end
    end
  end

  describe '#hour_default' do
    context 'time present' do
      it 'returns hour in DC time' do
        Timecop.freeze(Time.parse("10:00:00 UTC")) do
          auction = build(:auction, delivery_due_at: Time.current)
          view_model = Admin::EditAuctionViewModel.new(auction)

          expect(view_model.hour_default('delivery_due')).to eq '6'
        end
      end
    end

    context 'time not present' do
      it 'returns default' do
        auction = build(:auction, delivery_due_at: nil)
        view_model = Admin::EditAuctionViewModel.new(auction)

        expect(view_model.hour_default('delivery_due')).to eq '1'
      end
    end
  end

  describe '#minute_default' do
    context 'time present' do
      it 'returns minutes for time entered' do
        Timecop.freeze(Time.parse("10:30:00 UTC")) do
          auction = build(:auction, delivery_due_at: Time.current)
          view_model = Admin::EditAuctionViewModel.new(auction)

          expect(view_model.minute_default('delivery_due')).to eq '30'
        end
      end
    end

    context 'time not present' do
      it 'returns default' do
        auction = build(:auction, delivery_due_at: nil)
        view_model = Admin::EditAuctionViewModel.new(auction)

        expect(view_model.minute_default('delivery_due')).to eq '00'
      end
    end
  end

  describe '#meridiam' do
    context 'time present' do
      it 'returns meridiam for time value' do
        Timecop.freeze(Time.parse("10:00:00 UTC")) do
          auction = build(:auction, delivery_due_at: Time.current)
          view_model = Admin::EditAuctionViewModel.new(auction)

          expect(view_model.meridiem_default('delivery_due')).to eq "AM"
        end
      end
    end

    context 'time not present' do
      it 'returns default' do
        auction = build(:auction, delivery_due_at: nil)
        view_model = Admin::EditAuctionViewModel.new(auction)

        expect(view_model.meridiem_default('delivery_due')).to eq "PM"
      end
    end
  end

  describe '#date_default' do
    context 'date present' do
      it 'returns the date value of the field' do
        auction = build(:auction, delivery_due_at: 1.day.ago)
        view_model = Admin::EditAuctionViewModel.new(auction)

        expect(view_model.date_default('delivery_due')).to eq(
          DcTimePresenter.convert(1.day.ago).to_date
        )
      end
    end

    context 'date not present' do
      it 'returns todays date' do
        auction = build(:auction, delivery_due_at: nil)
        view_model = Admin::EditAuctionViewModel.new(auction)

        expect(view_model.date_default('delivery_due')).to eq(
          DcTimePresenter.convert(DefaultDateTime.new.convert).to_date
        )
      end
    end
  end
end
