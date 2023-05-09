class CreatePackageVersions < ActiveRecord::Migration[7.0]
  def change
    create_table :package_versions do |t|
      t.references :package, null: false, foreign_key: true
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
