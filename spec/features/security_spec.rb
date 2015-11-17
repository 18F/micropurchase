require 'rails_helper'
require 'brakeman'

RSpec.feature "Security (via Brakeman static code analysis)" do
  before do
    tracker = Brakeman.run(Rails.root.to_s)
    @warnings = tracker.checks.warnings
  end

  scenario "The site has zero security warnings" do
    expect(@warnings.length).to eq(0), "Expected 0 security warnings, got: \n #{@warnings.map(&:to_s)}."
  end
end
