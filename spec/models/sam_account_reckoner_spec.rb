require 'rails_helper'

describe SamAccountReckoner do
  describe '#set!' do
    context 'when user has a valid duns number' do
      it 'uses the client to determine if there is a valid sam account' do
        user = FactoryGirl.create(:user, sam_status: :sam_pending)
        client = double('samwise client')
        allow(Samwise::Client).to receive(:new).and_return(client)
        vendor_summary = {
          in_sam: true,
          small_business: true
        }
        allow(client).to receive(:get_vendor_summary)
          .with(duns: user.duns_number)
          .and_return(vendor_summary)

        SamAccountReckoner.new(user).set!

        expect(user).to be_sam_accepted
      end

      context 'and DUNS has already been accepted' do
        context 'and the user provides a big business DUNS' do
          it 'sets user.small_business to false' do
            user = FactoryGirl.create(:user, :big_business, sam_status: :sam_accepted)
            client = double('samwise client')
            allow(Samwise::Client).to receive(:new).and_return(client)
            vendor_summary = {
              in_sam: true,
              small_business: false
            }
            allow(client).to receive(:get_vendor_summary)
              .with(duns: user.duns_number)
              .and_return(vendor_summary)

            SamAccountReckoner.new(user).set!

            expect(user).to_not be_small_business
          end
        end

        context 'and the user provides a small business DUNS' do
          it 'sets user.small_business to true' do
            user = FactoryGirl.create(:user, :small_business, sam_status: :sam_accepted)
            client = double('samwise client')
            allow(Samwise::Client).to receive(:new).and_return(client)
            vendor_summary = {
              in_sam: true,
              small_business: true
            }
            allow(client).to receive(:get_vendor_summary)
              .with(duns: user.duns_number)
              .and_return(vendor_summary)

            SamAccountReckoner.new(user).set!

            expect(user.small_business).to eq(true)
          end
        end
      end
    end

    context 'when the duns number is not present in sam' do
      it 'use the client to find if there is a SAM account' do
        user = FactoryGirl.build(:user, sam_status: :sam_rejected, duns_number: '1234567')
        client = double('samwise client')
        allow(Samwise::Client).to receive(:new).and_return(client)
        vendor_summary = {
          in_sam: false,
          small_business: false
        }
        allow(client).to receive(:get_vendor_summary)
          .with(duns: user.duns_number)
          .and_return(vendor_summary)

        SamAccountReckoner.new(user).set!

        expect(user).to be_sam_rejected
      end
    end
  end

  describe '#set_default_status' do
    context 'when the user is not persisted' do
      it 'does not change the sam status' do
        user = FactoryGirl.build(:user, sam_status: :sam_accepted)

        SamAccountReckoner.new(user).set_default_sam_status

        expect(user).to be_sam_accepted
      end
    end

    context 'when the duns number has not changed' do
      it 'does not change the sam status' do
        user = FactoryGirl.create(:user, sam_status: :sam_accepted)

        SamAccountReckoner.new(user).set_default_sam_status

        expect(user).to be_sam_accepted
      end
    end

    context 'when the duns number has changed' do
      it 'clears the sam status validation' do
        old_duns = "123456789"
        user = FactoryGirl.create(:user, sam_status: :sam_accepted, duns_number: old_duns)
        user.duns_number = '987654321'

        SamAccountReckoner.new(user).set_default_sam_status

        expect(user).to be_sam_pending
      end
    end
  end
end
