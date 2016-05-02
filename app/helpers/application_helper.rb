module ApplicationHelper
  def controller_class
    controller.class.name.include?('Admin') ? 'admin' : 'bidder'
  end
end
