class CreateNames < ActiveRecord::Migration
  def change
    create_table :names do |t|
      t.string :personal, default: ""
      t.string :middle, default: ""
      t.string :family, default: ""
      t.belongs_to :person
      t.string :type, index: true
      t.timestamps
      t.index [:personal, :family, :type, :person_id], unique: true
    end
  end
end
