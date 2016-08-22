class Url
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  attr_reader :path_name, :link_text, :params

  def initialize(link_text:, path_name:, params: { })
    @link_text = link_text
    @path_name = path_name
    @params = params
  end

  def to_s
    link_to link_text, send("#{path_name}_path", params)
  end
end
