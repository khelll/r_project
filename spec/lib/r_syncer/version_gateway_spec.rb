require 'rails_helper'

module RSyncer
  describe VersionGateway do
    describe '#list' do
      let(:response) { fixture_content('versions.txt') }
      subject(:list) { VersionGateway.list }
      before do
        stub_request(:get, VersionGateway.versions_url)
        .to_return(body: response)
      end
      it 'returns a list of parsed values' do
        expect(list).to be_a(Array)
        expect(list.first['Package']).to eq('ABCp2')
        expect(list.first['Version']).to eq('1.1')
      end
    end

    describe '#version' do
      let(:name) { 'ABCp2' }
      let(:ver) { '1.1' }
      let(:description) { version_description('ver_desc.txt') }
      let(:version) { described_class.version(name, ver) }
      before do
        stub_request(:get, described_class.version_url(name, ver))
        .to_return(body: fixture_content('ABCp2_1.1.tar.gz'))
      end
      it 'returns a list of parsed values' do
        expect(version['Package']).to eq(description.fetch('Package'))
        expect(version['Version']).to eq(description.fetch('Version'))
        expect(version['Title']).to eq(description.fetch('Title'))
        expect(version['Description']).to eq(description.fetch('Description'))
        expect(version['Author']).to eq(description.fetch('Author'))
        expect(version['Maintainer']).to eq(description.fetch('Maintainer'))
        expect(version['Date/Publication'].to_s)
        .to eq(description.fetch('Date/Publication'))
      end
    end
  end
end
