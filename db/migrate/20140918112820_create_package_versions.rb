class CreatePackageVersions < ActiveRecord::Migration
  def change
    create_table :package_versions do |t|
      t.string :name
      t.string :version
      t.datetime :published_at
      t.text :title
      t.text :description
      t.text :authors
      t.text :maintainers
      t.integer :latest, default: 1
      t.timestamps
    end
  end
end
