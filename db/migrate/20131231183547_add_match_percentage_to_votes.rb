class AddMatchPercentageToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :match_percentage, :float
  end
end
