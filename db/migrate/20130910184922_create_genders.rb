class CreateGenders < ActiveRecord::Migration
  def change
    create_table :genders do |t|
      t.integer :type, index: true
      t.float :confidence, default: 0.0
      t.string :type, index: true
      t.text :data
      t.belongs_to :person, index: true
    end
  end
end
