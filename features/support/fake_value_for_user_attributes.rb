def fake_value_for_user_attribute(attribute)
  case attribute
  when 'credit_card_form_url'
    Faker::Internet.url.gsub('http:', 'https:')
  when 'name'
    Faker::Name.name
  when 'duns_number'
    Faker::Company.duns_number
  when 'email'
    "random#{rand(10000)}@example.com"
  else
    fail "Unknown attribute '#{attribute}'"
  end
end
