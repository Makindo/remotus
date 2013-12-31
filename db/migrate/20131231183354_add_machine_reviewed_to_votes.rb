class AddMachineReviewedToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :machine_reviewed, :boolean, default: false
  end
end
