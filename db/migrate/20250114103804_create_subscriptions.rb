class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :description
      t.decimal :default_amount, precision: 10, scale: 2
      t.integer :subscription_type, default: 0
      t.timestamps
    end
  end
end
