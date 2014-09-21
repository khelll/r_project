require 'rails_helper'

module RSyncer
  describe Syncer do
    describe '#perform' do
      let(:ver_desc) { version_description('ver_desc.txt') }
      let(:syncer) { described_class.new }
      before do
        stub_request(:get, VersionGateway.versions_url)
        .to_return(body: fixture_content('versions.txt'))
        stub_request(:get, VersionGateway.version_url('ABCp2', '1.1'))
        .to_return(body: fixture_content('ABCp2_1.1.tar.gz'))
      end

      context 'no duplication' do
        context 'no previous versions of the same package' do
          before do
            2.times { FactoryGirl.create(:package_version) }
            syncer.perform
          end
          subject(:package_version) { PackageVersion.last }
          it { is_expected.to be_a_version(ver_desc) }
        end

        context 'previous versions of the same package exists' do
          before do
            FactoryGirl.create(
              :package_version, name: 'ABCp2',
              version: '0.2', latest: 0
            )
            FactoryGirl.create(
              :package_version, name: 'ABCp2',
              version: '0.4', latest: 1
            )
            syncer.perform
          end

          subject(:package_version) { PackageVersion.last }
          it { is_expected.to be_a_version(ver_desc) }

          it 'unmarks older versions from being the latest' do
            version = PackageVersion
            .for_package_and_version('ABCp2', '0.4').first
            expect(version.latest?).to eq(false)
          end
        end
      end

      context 'duplication' do
        before do
          2.times { FactoryGirl.create(:package_version) }
          2.times { syncer.perform }
        end

        subject { PackageVersion.count }
        it { is_expected.to eq(3) }
      end
    end
  end
end
