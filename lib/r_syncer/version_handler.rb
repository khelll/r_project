module RSyncer
  # Fetchs the version info and indexes them if not available.
  class VersionHandler
    attr_accessor :package, :version, :version_gateway,
      :package_version_mapper, :logger

    def self.perform(attributes, options = {})
      new(attributes, options).perform
    end

    def initialize(attributes, options = {})
      self.package = attributes.fetch('Package')
      self.version = attributes.fetch('Version')
      self.logger = options.fetch(:logger) { Rails.logger }
      self.version_gateway = options.fetch(:version_gateway) { VersionGateway }
      self.package_version_mapper =
        options.fetch(:package_version_mapper) { PackageVersionMapper }
    end

    def perform
      return if version_exists?
      release_version!
    end

    private

    def version_exists?
      PackageVersion
      .for_package_and_version(package, version)
      .first.present?
    end

    def release_version!
      package_version.release!
    rescue => e
      logger.info e.message
    end

    def package_version
      package_version_mapper.perform(gateway_info)
    end

    def gateway_info
      logger.info "Fetching new version: #{package} #{version}"
      version_gateway.version(package, version)
    end
  end
end
