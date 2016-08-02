class Url
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  attr_reader :path_name, :link_text

  def initialize(link_text:, path_name:)
    @link_text = link_text
    @path_name = path_name
  end

  def to_s
    link_to link_text, send("#{path_name}_path")
  end
end
