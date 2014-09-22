require 'rails_helper'

module RSyncer
  describe VersionHandler do
    describe '#perform' do
      let(:data) { fixture_content('ABCp2_1.1.tar.gz') }
      let(:description) { version_description('ver_desc.txt') }
      let(:version_gateway) { double(version: description) }
      let(:tmp_package_version) { FactoryGirl.build(:tmp_package_version) }
      let(:package_version_mapper) { double(perform: tmp_package_version) }
      let(:handler) do
        VersionHandler.new(
          description, version_gateway: version_gateway,
          package_version_mapper: package_version_mapper
        )
      end
      
      context 'no duplication' do
        it 'fetches the gateway versions list' do
          handler.perform
          expect(version_gateway)
          .to have_received(:version).with('ABCp2', '1.1')
        end

        it 'unmarks any older versions of the package as the latest' do
          allow(PackageVersion).to receive(:clear_package_latest_versions)
          handler.perform
          expect(PackageVersion)
          .to have_received(:clear_package_latest_versions).with('ABCp2')
        end

        it 'creates a package version formed by a mapper' do
          handler.perform
          expect(package_version_mapper)
          .to have_received(:perform).with(description)
          expect(PackageVersion.last).to eq(tmp_package_version)
        end
      end

      context 'duplication' do
        before { handler.perform }

        it 'does nothing' do
          handler.perform
          expect(version_gateway).to have_received(:version).once
        end
      end

    end
  end
end
