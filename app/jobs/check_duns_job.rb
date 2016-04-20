class CheckDunsJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    SamAccountReckoner.new(user).set!
  end
end
