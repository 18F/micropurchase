Given(/^masquerading is turned on$/) do
  ENV['MASQUERADE'] = 'true'
end

Given(/^masquerading is turned off$/) do
  ENV['MASQUERADE'] = 'false'
end
