require 'rails_helper'
require 'brakeman'

RSpec.feature "Security (via Brakeman static code analysis)" do
  before do
    tracker = Brakeman.run(Rails.root.to_s)
    @brakeman_warnings = tracker.checks.warnings

    @gemfile_vulns = `bundle exec hakiri gemfile:scan`
    @ruby_rails_vulns = `bundle exec hakiri system:scan -m hakiri_manifest.json`
  end

  scenario "The site has zero Brakeman security warnings" do
    expect(@brakeman_warnings.length).to eq(0), "Expected 0 security warnings, got: \n #{@brakeman_warnings.map(&:to_s)}."
  end

  scenario "The Gemfile does not depend on vulnerable gems" do
    expect(@gemfile_vulns).to have_content("No vulnerabilities found. Keep it up!")
  end

  scenario "The Ruby and Rails versions have no known (CVE) vulnerabilities" do
    expect(@ruby_rails_vulns).to have_content("No vulnerabilities found. Keep it up!")
  end
end
