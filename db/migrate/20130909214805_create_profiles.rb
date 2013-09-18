class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.belongs_to :person, index: true
      t.string :external_id, null: false
      t.string :type, null: false
      t.text :data, null: false
      t.string :location
      t.string :name
      t.string :username, index: true
      t.boolean :exists, default: false
      t.timestamps
      t.index [:external_id, :type], unique: true
      t.index :exists, where: "(exists IS FALSE)"
    end
  end
end
