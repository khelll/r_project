require 'rails_helper'

module RIndexer
  describe Indexer do
    describe '#perform' do
      let(:description) { version_description('ver_desc.txt') }
      let(:indexer) { described_class.new }
      
      before do
        stub_request(:get, VersionGateway.versions_url)
        .to_return(body: fixture_content('versions.txt'))
        stub_request(:get, VersionGateway.version_url('ABCp2', '1.1'))
        .to_return(body: fixture_content('ABCp2_1.1.tar.gz'))
      end

      context 'version was not indexed before' do
        context 'no previous versions of the same package' do
          
          before do
            2.times { FactoryGirl.create(:package_version) }
            indexer.perform
          end

          it 'adds the record' do
            expect(PackageVersion.count).to eq(3)
          end

          it 'has the correct version data' do
            expect(PackageVersion.last).to be_a_version(description)
          end

        end

        context 'previous versions of the same package exists' do
         
          before do
            FactoryGirl.create(
              :package_version, package_name: 'ABCp2',
              code: '0.2', latest: 0
            )
            FactoryGirl.create(
              :package_version, package_name: 'ABCp2',
              code: '0.4', latest: 1
            )
            indexer.perform
          end

          it 'adds the record' do
            expect(PackageVersion.count).to eq(3)
          end

          it 'has the correct version data' do
            expect(PackageVersion.last).to be_a_version(description)
          end

          it 'marks the newer version as the latest' do
            expect(PackageVersion.last).to be_latest
          end

          it 'unmarks older versions from being the latest' do
            version = PackageVersion
            .for_package_and_version('ABCp2', '0.4').first
            expect(version.latest?).to eq(false)
          end
        
        end
      end

      context 'version was indexed before' do
        
        before do
          2.times { FactoryGirl.create(:package_version) }
          2.times { indexer.perform }
        end

        subject { PackageVersion.count }
        
        it { is_expected.to eq(3) }
      
      end
    end
  end
end
