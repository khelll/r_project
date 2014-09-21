require 'rails_helper'

RSpec.describe 'ListPackages', type: :feature do
  before do
    FactoryGirl.create(:package_version)
    FactoryGirl.create(:package_version)
    FactoryGirl.create(:package_version, latest: 0)
    visit root_path
  end

  it 'lists the latest versions of each package' do
    Package.latest_versions.each do |version|
      expect(page).to have_content(version.name)
      expect(page).to have_content(version.version)
      expect(page).to have_content(version.title)
      expect(page).to have_content(version.published_at)
    end
  end

  it 'ignores previous versions of each package' do
    a_version = Package.old_versions.first
    expect(page).not_to have_content(a_version.name)
  end

end
