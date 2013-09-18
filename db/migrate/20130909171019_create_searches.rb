class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :query, null: false
      t.string :type, null: false
      t.timestamps
      t.index [:query, :type], unique: true
    end
  end
end
