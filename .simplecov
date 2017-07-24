SimpleCov.add_filter '/.bundle'
SimpleCov.add_filter '/spec'
SimpleCov.add_filter '/features'
SimpleCov.add_filter '/vendor'

if ENV['CIRCLE_ARTIFACTS']
  dir = File.join(ENV['CIRCLE_ARTIFACTS'], "coverage")
  SimpleCov.coverage_dir(dir)
end
SimpleCov.start
