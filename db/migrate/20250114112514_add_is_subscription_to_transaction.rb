class AddIsSubscriptionToTransaction < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :subscription_code, :string, default: nil
  end
end
