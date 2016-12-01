require 'rails_helper'

RSpec.describe Api::V0::BusinessDaysController do
  describe 'show' do
    it 'should return a date N business days from the date and time in the DC time zone' do
      get :show, date: '2016-08-30', time: '13:00', day_count: '1'
      json = JSON.parse(response.body)
      expect(json['date']).to eq("August 31, 2016 01:00:00 PM EDT")
    end

    it 'should handle holidays correctly' do
      BusinessTime::Config.holidays << Date.parse('2016-09-05')
      get :show, date: '2016-09-01', time: '13:00', day_count: '5'
      json = JSON.parse(response.body)
      expect(json['date']).to eq("September 09, 2016 01:00:00 PM EDT")
    end
  end
end
