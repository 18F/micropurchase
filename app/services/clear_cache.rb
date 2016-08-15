class ClearCache
  def perform
    ApplicationController.expire_page(app.insights_path)
  end
end
