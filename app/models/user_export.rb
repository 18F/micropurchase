require 'csv'

class UserExport
  class Error < StandardError; end

  def initialize
    @users = User.all
  end

  def export_csv
    CSV.generate do |csv|
      csv << header_values

      users.each do |u|
        user = UserPresenter.new(u)
        next if user.admin?
        csv << data_values(user)
      end
    end
  end

  private

  attr_reader :users

  def header_values
    ["Name",
     "Email Address",
     "Github ID",
     "In SAM?",
     "Small Business"]
  end

  def data_values(user)
    [user.name,
     user.email,
     user.github_id,
     user.sam_status_label,
     user.small_business_label]
  end
end
