module RSyncer
  # Syning happens here
  class Syncer
    def self.perform(options = {})
      new(options).perform
    end

    attr_accessor :max_fetch, :version_gateway, :version_handler

    def initialize(options = {})
      self.max_fetch = options.fetch(:max_fetch) { :all }
      self.version_gateway = options.fetch(:version_gateway) { VersionGateway }
      self.version_handler = options.fetch(:version_handler) { VersionHandler }
    end

    def perform
      versions_list.each { |version| version_handler.perform(version) }
    end

    private

    def versions_list
      version_gateway.list(max_fetch)
    end
  end
end
