class FixEncoding < ActiveRecord::Migration
  def change
    attrs = ['name', 'version', 'title', 'description', 'authors', 'maintainers']
    PackageVersion.all.each do |version|
      updated = {}
      attrs.each do |attr|
        value = version.send(attr)
        if (value.encoding == Encoding::ASCII_8BIT)
          puts "Invalid attribute #{attr}: #{value} for version: #{version.name}"
          value.force_encoding('ISO-8859-1').encode!('UTF-8')
          updated[attr] = value
        end
      end
      version.update_columns(updated) unless updated.empty?
    end
  end
end
