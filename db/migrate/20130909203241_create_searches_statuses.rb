class CreateSearchesStatuses < ActiveRecord::Migration
  def change
    create_join_table :searches, :statuses do |t|
      t.index :search_id
      t.index :status_id
    end
  end
end
