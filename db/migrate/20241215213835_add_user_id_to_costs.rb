class AddUserIdToCosts < ActiveRecord::Migration[8.0]
  def change
    add_column :costs, :user_id, :integer
  end
end
