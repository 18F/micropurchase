SimpleCov.add_filter '/.bundle'
SimpleCov.add_filter '/spec'
SimpleCov.add_filter '/features'

if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate_batch'
  CodeclimateBatch.start
else
  SimpleCov.start
end
