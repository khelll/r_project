require 'dcf'

module UtilityHelpers
  def fixture_content(file_name)
    File.open(fixture_path + '/' + file_name).read
  end

  def version_description(file_name)
    Dcf.parse(fixture_content(file_name)).first
  end
end
