class PackageVersion < ActiveRecord::Base
  scope :latest, -> { where(latest: true) }
  scope :old, -> { where(latest: false) }
  scope :for_package, -> (name) { where(name: name) }
  scope :for_package_and_version,
    -> (name, version) { for_package(name).where(version: version) }

  validates :version, uniqueness: { scope: :name, message: 'already exists!' }

  def self.clear_package_latest_versions(package)
    for_package(package).update_all(latest: 0)
  end

  def latest?
    latest == 1
  end

  def release!
    if valid?
      self.class.clear_package_latest_versions(name)
      save(validate: false)
    else
      fail ActiveRecord::RecordInvalid.new(self)
    end
  end

  # presetners are better for this case.
  def download_url
    RSyncer::VersionGateway.version_url(name, version)
  end
end
