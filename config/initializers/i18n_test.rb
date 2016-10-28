if Rails.env.test? || Rails.env.development?
  class I18n::JustRaiseExceptionHandler < I18n::ExceptionHandler
    def call(exception, locale, key, options)
      if exception.is_a?(I18n::MissingTranslation) && key.to_s != 'i18n.plural.rule'
        fail exception.to_exception
      else
        super
      end
    end
  end

  I18n.exception_handler = I18n::JustRaiseExceptionHandler.new
end
