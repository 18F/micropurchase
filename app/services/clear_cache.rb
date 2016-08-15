class ClearCache
  include Rails.application.routes.url_helpers

  def perform
    ApplicationController.expire_page(insights_path)
  end
end
