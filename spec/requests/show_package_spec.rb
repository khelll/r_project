require 'rails_helper'

RSpec.describe 'ShowPackages', type: :feature do
  let(:package) { Package.new('test') }

  before do
    FactoryGirl.create(:package_version, package_name: package.name)
    FactoryGirl.create(:package_version, package_name: package.name, latest: 0)
    visit package_path(package)
  end

  it 'lists the latest versions of each package' do
    expect(page).to have_content(package.name)
    package.versions.each do |version|
      expect(page).to have_content(version.code)
      expect(page).to have_content(version.title)
      expect(page).to have_content(version.published_at)
      expect(page).to have_content(version.description)
      expect(page).to have_content(version.authors)
      expect(page).to have_content(version.maintainers)
    end
  end

end
