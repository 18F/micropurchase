When(/^the cache clears$/) do
  ClearCache.new.perform
end

When(/^the cache has not yet cleared$/) do
  # here for readability
  # does nothing
end
