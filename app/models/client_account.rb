class ClientAccount < ActiveRecord::Base
  validates :name, presence: true
  validates :tock_id, presence: true

  def to_s
    "#{name} (#{billable_to_s})"
  end

  private

  def billable_to_s
    if billable
      "Billable"
    else
      "Not billable"
    end
  end
end
