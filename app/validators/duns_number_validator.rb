require 'samwise'

class DunsNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.present? && invalid_duns_number?(value)
      record.errors[attribute] << (I18n.t('activerecord.errors.models.user.attributes.duns_number.invalid'))
    end
  end

  private

  def invalid_duns_number?(value)
    !contains_only_integers?(formatted_duns(value))
  end

  def formatted_duns(value)
    Samwise::Util.format_duns(duns: value)
  end

  def contains_only_integers?(duns_number)
    duns_number.match(/\A\d{8,13}\z/)
  end
end
