class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.timestamps
      t.string :name, null: false
      t.string :description
    end

    create_table :account_users do |t|
      t.references :account, null: false, foreign_key: { on_delete: :cascade }
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.timestamps

      t.index [ :account_id, :user_id ], unique: true
    end
  end
end
