class RemovePositiveNegativeFromStatuses < ActiveRecord::Migration
  def change
    remove_column :statuses, :positive
    remove_column :statuses, :negative    
  end
end
