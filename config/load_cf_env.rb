require 'json'

begin
  vcap = ENV['VCAP_SERVICES']
  JSON.parse(vcap)["user-provided"].each do |service|
    if service['name'] == 'new-relic'
      service['credentials'].each do |key, value|
        upcase_key = "NEW_RELIC_#{key.upcase}"
        ENV[upcase_key] = value
      end
    end
  end
rescue
  puts 'Error loading env vars'
end
