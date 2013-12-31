class AddHumanReviewedToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :human_reviewed, :boolean, default: false
  end
end
