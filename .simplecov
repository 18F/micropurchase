SimpleCov.add_filter '/.bundle'
SimpleCov.add_filter '/spec'
SimpleCov.add_filter '/features'
SimpleCov.add_filter '/vendor'

if ENV['CI']
  ENV['DEFAULT_BRANCH'] = 'develop'
  require 'codeclimate_batch'
  CodeclimateBatch.start
else
  SimpleCov.start
end
