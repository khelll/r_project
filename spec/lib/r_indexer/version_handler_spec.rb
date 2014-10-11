require 'rails_helper'

module RIndexer
  describe VersionHandler do
    describe '#perform' do
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

      context 'version was not indexed before' do
        
        before { handler.perform }

        it 'releases the version' do
          expect(package_version).to have_received(:release!)
        end
      end

      context 'version was indexed before' do

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
