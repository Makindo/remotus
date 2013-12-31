class ChangeVotesValueToMatched < ActiveRecord::Migration
  def change
    rename_column :votes, :value, :matched
  end
end
