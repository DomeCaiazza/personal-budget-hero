class AddCodeToSubscription < ActiveRecord::Migration[8.0]
  def change
    add_column :subscriptions, :code, :string
  end
end
