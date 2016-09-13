require 'rails_helper'

describe Eligibilities::SmallBusiness do
  describe '#eligible?' do
    context 'user is sam accepted' do
      context 'user is small business' do
        it 'is true' do
          user = build(:user, sam_status: :sam_accepted, small_business: true)

          expect(Eligibilities::SmallBusiness.new.eligible?(user)).to eq true
        end
      end

      context 'user is not small business' do
        it 'is false' do
          user = build(:user, sam_status: :sam_accepted, small_business: false)

          expect(Eligibilities::SmallBusiness.new.eligible?(user)).to eq false
        end
      end
    end

    context 'user is not sam accepted' do
      it 'is false' do
        user = build(:user, sam_status: :sam_pending)

        expect(Eligibilities::SmallBusiness.new.eligible?(user)).to eq false
      end
    end
  end
end
