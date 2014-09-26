require 'rails_helper'

RSpec.describe PackageVersion, :type => :model do
  describe '#release!' do
    let(:package_version) { FactoryGirl.build(:package_version) }

    it 'unmarks older versions from being the latest' do
      allow(described_class).to receive(:clear_package_latest_versions)

      package_version.release!

      expect(described_class)
      .to have_received(:clear_package_latest_versions)
      .with(package_version.name)
    end

    it 'saves the object' do
      package_version.release!
      expect(described_class.count).to eq(1)
    end

    it 'raises an error in case of validation error' do
      # simulate a uniqueness situation
      package_version.save
      new_package_version = FactoryGirl.build(
        :package_version,
        name: package_version.name, version: package_version.version
      )
      expect { new_package_version.release! }
      .to raise_error(ActiveRecord::RecordInvalid)
    end

  end
end
