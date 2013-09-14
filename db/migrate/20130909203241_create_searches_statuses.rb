class CreateSearchesStatuses < ActiveRecord::Migration
  def change
    create_join_table :searches, :statuses
  end
end
