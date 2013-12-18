class AddAccountIdexToSearch < ActiveRecord::Migration
  def change
    add_reference :searches, :account, index: true
  end
end
