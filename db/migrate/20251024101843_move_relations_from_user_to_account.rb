class MoveRelationsFromUserToAccount < ActiveRecord::Migration[8.0]
  def change
    add_reference :transactions, :account, null: false, foreign_key: { on_delete: :cascade }
    add_reference :categories, :account, null: false, foreign_key: { on_delete: :cascade }
    add_reference :subscriptions, :account, null: false, foreign_key: { on_delete: :cascade }

    remove_reference :transactions, :user
    remove_reference :categories, :user
    remove_reference :subscriptions, :user
  end
end
