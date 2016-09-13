require 'rails_helper'

describe Eligibilities::InSam do
  describe '#eligible?' do
    context 'user is sam accepted' do
      it 'is true' do
        user = build(:user, sam_status: :sam_accepted)

        expect(Eligibilities::InSam.new.eligible?(user)).to eq true
      end
    end

    context 'user is not sam accepted' do
      it 'is false' do
        user = build(:user, sam_status: :sam_pending)

        expect(Eligibilities::InSam.new.eligible?(user)).to eq false
      end
    end

    context 'user is admin' do
      it 'is false' do
        admin_double = double(verify?: true)
        allow(Admins).to receive(:new).and_return(admin_double)
        user = build(:user, sam_status: :sam_accepted)

        expect(Eligibilities::InSam.new.eligible?(user)).to eq false
      end
    end
  end
end
