class AddRatingToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :rating, :integer
  end
end
