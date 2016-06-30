class Delayed::Job < ActiveRecord::Base
  self.table_name = 'delayed_jobs'
  attr_accessible :auction_id
  belongs_to :auction, polymorphic: true
end
