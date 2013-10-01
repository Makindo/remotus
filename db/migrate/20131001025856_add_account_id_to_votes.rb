class AddAccountIdToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :account_id, :integer, index: true
  end
end
