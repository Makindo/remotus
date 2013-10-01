class AddSearchIdStatusIdAccountIdIndexOnVotes < ActiveRecord::Migration
  def change
    add_index :votes, [:search_id, :status_id, :account_id], unique: true
  end
end
