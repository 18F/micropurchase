# NOTE: we are parsing times in DC time, but storing them in the DB in UTC
Chronic.time_class = ActiveSupport::TimeZone['Eastern Time (US & Canada)']
