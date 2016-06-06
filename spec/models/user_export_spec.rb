require 'rails_helper'

RSpec.describe UserExport do
  describe '#export_csv' do
    context 'for a user not in SAM yet' do
      it 'should return the correct CSV' do
        user = FactoryGirl.create(:user, sam_status: :sam_pending, small_business: false)

        export = UserExport.new.export_csv

        parsed = CSV.parse(export)

        expect(parsed[1][0]).to include(user.name)
        expect(parsed[1][1]).to include(user.email)
        expect(parsed[1][2]).to include(user.github_login)
        expect(parsed[1][3]).to include('No')
        expect(parsed[1][4]).to include('N/A')        
      end
    end
    
    context 'for a small-business user in SAM' do
      it 'should return the correct CSV' do
        user = FactoryGirl.create(:user, :small_business)

        export = UserExport.new.export_csv

        parsed = CSV.parse(export)

        expect(parsed[1][0]).to include(user.name)
        expect(parsed[1][1]).to include(user.email)
        expect(parsed[1][2]).to include(user.github_login)
        expect(parsed[1][3]).to include('Yes')
        expect(parsed[1][4]).to include('Yes')
      end
    end

    context 'for a user in SAM who is not a small business' do
      it 'should return the correct CSV' do
        user = FactoryGirl.create(:user, :not_small_business)

        export = UserExport.new.export_csv

        parsed = CSV.parse(export)

        expect(parsed[1][0]).to include(user.name)
        expect(parsed[1][1]).to include(user.email)
        expect(parsed[1][2]).to include(user.github_login)
        expect(parsed[1][3]).to include('Yes')
        expect(parsed[1][4]).to include('No')
      end
    end
  end
end
