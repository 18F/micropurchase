SimpleCov.add_filter '/.bundle'
SimpleCov.add_filter '/spec'
SimpleCov.add_filter '/features'

if ENV['CI']
  require 'codeclimate_batch'
  CodeclimateBatch.start
else
  SimpleCov.start
end
