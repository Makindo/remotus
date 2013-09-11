class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :query, null: false
      t.string :type, null: false
      t.index [:query, :type], unique: true

      t.timestamps
    end
  end
end
