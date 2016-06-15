require 'samwise'

class DunsNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if !value.blank? && invalid_duns_number?(value)
      record.errors[attribute] << I18n.t('activerecord.errors.models.user.attributes.duns_number.invalid')
    end
  end

  private

  def invalid_duns_number?(value)
    !contains_thirteen_integers?(formatted_duns(value))
  end

  def formatted_duns(value)
    Samwise::Util.format_duns(duns: value)
  rescue Samwise::Error::InvalidFormat
    nil
  end

  def contains_thirteen_integers?(duns_number)
    if duns_number.present?
      duns_number.match(/\A\d{13}\z/)
    end
  end
end
