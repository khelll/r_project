require 'rails_helper'

module RIndexer
  describe PackageVersionMapper do
    let(:description) { version_description('ver_desc.txt') }
    
    subject(:package_version) { described_class.new(description).perform }
    
    it { is_expected.to be_a_version(description) }
  end
end
