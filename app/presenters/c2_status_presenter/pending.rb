class C2StatusPresenter::Pending < C2StatusPresenter::Base
  def header
    'Pending C2 approval'
  end

  def body
    'This auction has been sent to C2 for approval.'
  end
end
