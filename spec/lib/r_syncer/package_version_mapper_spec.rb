require 'rails_helper'

module RSyncer
  describe PackageVersionMapper do
    let(:ver_desc) { version_description('ver_desc.txt') }
    subject(:package_version) { described_class.new(ver_desc).perform }
    it { is_expected.to be_a_version(ver_desc) }
  end
end
