require 'rails_helper'
require 'brakeman'

RSpec.feature "Security" do
  context 'Static code analysis and check for CVEs' do
    before(:all) do
      @tracker = Brakeman.run(Rails.root.to_s)
      @gemfile_vulns = `bundle exec hakiri gemfile:scan`
      @ruby_rails_vulns = `bundle exec hakiri system:scan -m hakiri_manifest.json`
    end

    let(:brakeman_warnings) { @tracker.filtered_warnings }
    let(:gemfile_vulns) { @gemfile_vulns }
    let(:ruby_rails_vulns) { @ruby_rails_vulns }

    scenario "The site has zero Brakeman security warnings" do
      expect(brakeman_warnings.length).to eq(0), "Expected 0 security warnings, got: \n #{brakeman_warnings.map(&:to_s)}."
    end

    scenario "The Gemfile does not depend on vulnerable gems" do
      expect(gemfile_vulns).to have_content("No vulnerabilities found. Keep it up!")
    end

    scenario "The Ruby and Rails versions have no known (CVE) vulnerabilities" do
      expect(ruby_rails_vulns).to have_content("No vulnerabilities found. Keep it up!")
    end
  end
end
