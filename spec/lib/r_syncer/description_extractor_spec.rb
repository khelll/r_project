require 'rails_helper'

module RSyncer
  describe DescriptionExtractor do
    describe '#perform' do
      let(:data) { fixture_content('ABCp2_1.1.tar.gz') }
      let(:result) { fixture_content('ver_desc.txt') }
      subject { DescriptionExtractor.new(data).perform }
      it 'returns the content of the DESCRIPTION file' do
        expect(subject.chop).to eq(result)
      end
    end
  end
end
