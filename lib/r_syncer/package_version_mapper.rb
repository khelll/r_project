module RSyncer
  # A Mapper from VersionGateway domain model to PackageVersion
  # Based on Mapper design pattern
  # @see http://martinfowler.com/eaaCatalog/mapper.html
  class PackageVersionMapper
    attr_accessor :attributes

    def self.perform(attributes)
      new(attributes).perform
    end

    def initialize(attributes)
      self.attributes = attributes
    end

    def perform
      PackageVersion.new(package_version_attributes)
    end

    private

    def package_version_attributes
      {
        name: attributes['Package'],
        version: attributes['Version'],
        title: attributes['Title'],
        description: attributes['Description'],
        authors: attributes['Author'],
        maintainers: attributes['Maintainer'],
        published_at: attributes['Date/Publication']
      }
    end

    def contacts(data)
      match = data.match(/(.+) <(.+)>/)
      if match
        name, email = match[1..2]
        "#{name} - #{email}"
      else
        data
      end
    end
  end
end