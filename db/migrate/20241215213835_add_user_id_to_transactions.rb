class AddUserIdToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :user_id, :integer
  end
end
