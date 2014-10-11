require 'rubygems/package'
require 'zlib'

module RIndexer
  # Extracts the version description from a .tar.gz file.
  class DescriptionExtractor
    attr_accessor :data

    def self.perform(data)
      new(data).perform
    end

    def initialize(data)
      self.data = data
    end

    def perform
      with_tmp_file { |file_path| extract_description(file_path) }
    end

    private

    def with_tmp_file
      path = random_file_name
      File.open(path, 'wb') { |file| file.write(data) }
      yield(path)
    ensure
      FileUtils.rm(path)
    end

    def random_file_name
      rand(36**10).to_s(36)
    end

    def extract_description(tar_file_path)
      gz = Zlib::GzipReader.open(tar_file_path)
      tar_extract = Gem::Package::TarReader.new(gz)
      tar_extract.rewind
      tar_extract.each do |entry|
        break(utf8(entry.read)) if entry.full_name =~ /DESCRIPTION/
      end
    ensure
      gz.close
      tar_extract.close
    end

    def utf8(string)
      string.force_encoding('ISO-8859-1').encode!('UTF-8')
    end
  end
end
