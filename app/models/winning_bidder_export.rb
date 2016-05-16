require 'csv'

class WinningBidderExport
  class Error < StandardError; end

  def initialize(auction)
    @auction = auction
  end

  def export_csv
    CSV.generate do |csv|
      csv << header_values
      csv << data_values
    end
  end

  private

  attr_reader :auction

  def header_values
    [
      "13GG Vendor Name",
      "13JJ Vendor Address Line 1",
      '13KK Vendor Address Line 2',
      '13LL Vendor Address Line 3',
      '13MM Vendor Address City',
      '13NN Vendor Address State',
      '13PP Vendor Zip Code',
      '13QQ Vendor Country Code',
      '13RR Vendor Phone Number',
      '13SS Vendor Fax Number'
    ]
  end

  def data_values
    [
      legal_business_name,
      address_line_1,
      address_line_2,
      address_line_3,
      address_city,
      address_state,
      address_zip,
      address_country,
      phone,
      fax
    ]
  end

  def legal_business_name
    sam_data[:legalBusinessName]
  end

  def address_line_1
    sam_address[:line1]
  end

  def address_line_2
    sam_address[:line2] || nil
  end

  def address_line_3
    sam_address[:line3] || nil
  end

  def address_city
    sam_address[:city]
  end

  def address_state
    sam_address[:stateorProvince]
  end

  def address_zip
    sam_address[:zip] + zip_plus_4
  end

  def zip_plus_4
    sam_address[:zipPlus4] || ''
  end

  def address_country
    sam_address[:countryCode]
  end

  def phone
    sam_data[:govtBusinessPoc][:usPhone]
  end

  def fax
    sam_data[:govtBusinessPoc][:fax]
  end

  def sam_address
    sam_data[:samAddress]
  end

  def sam_data
    if duns_data['Code'] && duns_data['Code'] == 404
      fail WinningBidderExport::Error
    else
      duns_data.deep_symbolize_keys[:sam_data][:registration]
    end
  end

  def duns_data
    @_duns_data ||= client.get_duns_info(duns: winning_bidder.duns_number)
  end

  def winning_bidder
    WinningBid.new(auction).find.bidder
  end

  def client
    @client ||= Samwise::Client.new(api_key: DataDotGovCredentials.api_key)
  end
end
