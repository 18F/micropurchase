module ApplicationHelper
  def controller_class
    controller.class.name.include?('Admin') ? 'admin' : 'bidder'
  end

  def flash_errors
    result = nil
    if !flash.empty? && !flash[:error].nil?
      result = content_tag :div, class: 'usa-alert usa-alert-error', role: 'alert' do
        content_tag :div, class: 'usa-alert-body' do
          content_tag :h3, flash[:error], class: 'use-alert-heading'
        end
      end
    end
    flash.clear
    return result
  end
end
