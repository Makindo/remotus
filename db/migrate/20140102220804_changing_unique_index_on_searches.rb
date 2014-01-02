class ChangingUniqueIndexOnSearches < ActiveRecord::Migration
  def change
    remove_index :searches, [:query, :type]
    add_index :searches, [:query, :type, :account_id], unique: true
  end
end
