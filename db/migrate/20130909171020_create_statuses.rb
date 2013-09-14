class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.belongs_to :profile, index: true
      t.string :external_id, null: false
      t.text :text, null: false
      t.string :type, null: false
      t.text :data, null: false
      t.float :latitude
      t.float :longitude
      t.boolean :exists, default: false
      t.float :positive, default: 0.0
      t.float :negative, default: 0.0
      t.index [:external_id, :type], unique: true
      t.index :exists, where: "(exists IS FALSE)"

      t.timestamps
    end
  end
end
