class PackageVersion < ActiveRecord::Base
  scope :latest, -> { where(latest: true) }
  scope :old, -> { where(latest: false) }
  scope :for_package, -> (package_name) { where(package_name: package_name) }
  scope :for_package_and_version,
    -> (package_name, code) { for_package(package_name).where(code: code) }

  validates :code,
    uniqueness: { scope: :package_name, message: 'already exists!' }

  def self.clear_package_latest_versions(package_name)
    for_package(package_name).update_all(latest: 0)
  end

  def latest?
    latest == 1
  end

  def release!
    if valid?
      self.class.clear_package_latest_versions(package_name)
      save(validate: false)
    else
      fail ActiveRecord::RecordInvalid.new(self)
    end
  end

  # presetners are better for this case.
  def download_url
    RIndexer::VersionGateway.version_url(package_name, code)
  end
end
