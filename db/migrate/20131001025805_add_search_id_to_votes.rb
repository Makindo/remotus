class AddSearchIdToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :search_id, :integer, index: true
  end
end
