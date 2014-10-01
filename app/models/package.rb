class Package
  attr_accessor :name

  def self.latest_versions
    PackageVersion.latest.order(package_name: :asc)
  end

  def self.old_versions
    PackageVersion.old
  end

  def initialize(name)
    self.name = name
  end

  def versions
    PackageVersion.for_package(name).order(code: :desc)
  end

  def to_param
    name
  end
end
