class AddMatchedStatusIdToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :matched_status_id, :integer
  end
end
