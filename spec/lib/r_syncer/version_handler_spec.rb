require 'rails_helper'

module RSyncer
  describe VersionHandler do
    describe '#perform' do
      let(:data) { fixture_content('ABCp2_1.1.tar.gz') }
      let(:description) { version_description('ver_desc.txt') }
      let(:version_gateway) { double(version: description) }
      let(:package_version) { double(release!: nil) }
      let(:package_version_mapper) { double(perform: package_version) }
      let(:handler) do
        VersionHandler.new(
          description, version_gateway: version_gateway,
          package_version_mapper: package_version_mapper
        )
      end

      context 'no duplication' do
        before { handler.perform }
        it 'fetches the gateway version' do
          expect(version_gateway)
          .to have_received(:version).with('ABCp2', '1.1')
        end

        it 'builds a package version formed by a mapper' do
          expect(package_version_mapper)
          .to have_received(:perform).with(description)
        end

        it 'releases the package' do
          expect(package_version).to have_received(:release!)
        end
      end

      context 'duplication' do
        it 'does nothing' do
          mapped = FactoryGirl.build(:tmp_package_version)
          allow(package_version_mapper).to receive(:perform).and_return(mapped)
          2.times { handler.perform }
          expect(version_gateway).to have_received(:version).once
        end
      end

    end
  end
end
