class BooleanPresenter
  attr_reader :boolean

  def initialize(boolean)
    @boolean = boolean
  end

  def to_s
    if boolean == true
      'Yes'
    else
      'No'
    end
  end
end
