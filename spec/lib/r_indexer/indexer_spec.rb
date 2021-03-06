require 'rails_helper'

module RIndexer
  describe Indexer do
    describe '#perform' do
      let(:max_fetch) { 'value' }
      let(:version_list) { %w(v1, v2, v3) }
      let(:version_gateway) { double(list: version_list) }
      let(:version_handler) { double(perform: nil) }
      let(:indexer) do
        Indexer.new(
          version_gateway: version_gateway,
          version_handler: version_handler,
          max_fetch: max_fetch
        )
      end

      before { indexer.perform }

      it 'handles all listed versions' do
        version_list.each do |version|
          expect(version_handler)
          .to have_received(:perform).with(version, logger: indexer.logger)
        end
      end

    end
  end
end
