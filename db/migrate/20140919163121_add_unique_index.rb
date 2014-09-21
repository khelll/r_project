class AddUniqueIndex < ActiveRecord::Migration
  def change
    add_index :package_versions, [:name, :version], unique: true
  end
end
