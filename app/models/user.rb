class User < ActiveRecord::Base
  has_many :bids

  validates :email, allow_blank: true, email: true
  validate :validate_credit_card_form

  private

  def validate_credit_card_form
    return if credit_card_form_url.blank?

    uri = URI.parse(credit_card_form_url)

    case uri
    when URI::HTTPS
    # nothing to do here
    when URI::HTTP
      errors.add(:credit_card_form_url, 'must use HTTPS')
    else
      errors.add(:credit_card_form_url, 'is an invalid URL format')
    end
  rescue URI::InvalidURIError
    errors.add(:credit_card_form_url, 'is an invalid URL format')
  end
end
