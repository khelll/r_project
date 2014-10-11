module RIndexer
  # Syning happens here
  class Indexer
    def self.perform(options = {})
      new(options).perform
    end

    attr_accessor :max_fetch, :version_gateway, :version_handler, :logger

    def initialize(options = {})
      self.max_fetch = options.fetch(:max_fetch) { :all }
      self.logger = options.fetch(:logger) { Rails.logger }
      self.version_gateway = options.fetch(:version_gateway) { VersionGateway }
      self.version_handler = options.fetch(:version_handler) { VersionHandler }
    end

    def perform
      versions_list.each { |version| handle_version(version) }
    end

    private

    def handle_version(version)
      version_handler.perform(version, logger: logger)
    end

    def versions_list
      logger.info 'Fetching versions list'
      version_gateway.list(max_fetch)
    end
  end
end
