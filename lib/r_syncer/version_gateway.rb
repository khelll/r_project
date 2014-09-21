require 'dcf'

module RSyncer
  class VersionGateway
    class << self
      def versions_url
        @versions_url ||= 'http://cran.r-project.org/src/contrib/PACKAGES'
      end

      def version_url(name, version)
        "http://cran.r-project.org/src/contrib/#{name}_#{version}.tar.gz"
      end

      def list(max_fetch = :all)
        data = HTTP.get(versions_url).to_s
        limited_data = limit_versions(data, max_fetch)
        Dcf.parse(limited_data)
      end

      def version(name, version)
        url = version_url(name, version)
        file_data = HTTP.get(url).to_s
        description = RSyncer::DescriptionExtractor.perform(file_data)
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
