class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :value, index: true
      t.belongs_to :status, index: true
      t.timestamps
    end
  end
end
