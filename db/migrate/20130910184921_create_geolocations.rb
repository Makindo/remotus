class CreateGeolocations < ActiveRecord::Migration
  def change
    create_table :geolocations do |t|
      t.text :data
      t.text :query
      t.string :type, index: true
      t.belongs_to :person, index: true
      t.belongs_to :source, index: true, polymorphic: true
      t.string :city, default: ""
      t.string :state, default: "", index: true
      t.string :country, default: "", index: true
      t.string :zip
      t.float :latitude
      t.float :longitude
      t.timestamps
      t.index [:city, :state, :country, :person_id], unique: true
    end
  end
end
