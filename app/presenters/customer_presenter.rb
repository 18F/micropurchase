class CustomerPresenter < SimpleDelegator
  def model
    __getobj__
  end
end
