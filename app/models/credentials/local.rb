class Credentials::Local
  def get(*name)
    ENV[normalize(*name)]
  end

  private

  def normalize(*names)
    names.join('_').underscore.upcase
  end
end
