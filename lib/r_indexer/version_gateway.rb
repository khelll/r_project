require 'dcf'

module RIndexer
  # Graps the available packages/versions info from a web service
  # Based on Gateway design pattern
  # @see http://martinfowler.com/eaaCatalog/gateway.html
  class VersionGateway
    class << self
      def versions_url
        @versions_url ||= 'http://cran.r-project.org/src/contrib/PACKAGES'
      end

      def version_url(package_name, version_code)
        "http://cran.r-project.org/src/contrib/#{package_name}_#{version_code}.tar.gz"
      end

      def list(max_fetch = :all)
        data = HTTP.get(versions_url).to_s
        limited_data = limit_versions(data, max_fetch)
        Dcf.parse(limited_data)
      end

      def version(package_name, version_code)
        url = version_url(package_name, version_code)
        file_data = HTTP.get(url).to_s
        description = RIndexer::DescriptionExtractor.perform(file_data)
        Dcf.parse(description).first
      end

      private

      def limit_versions(data, max_fetch)
        if max_fetch == :all
          data
        else
          data.split("\n\n").take(max_fetch).join("\n\n")
        end
      end
    end
  end
end
