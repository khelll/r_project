# encoding: UTF-8
class FixVersionAttributesNaming < ActiveRecord::Migration
  def change
    change_table :package_versions do |t|
      t.rename :name, :package_name
      t.rename :version, :code
    end
  end
end
