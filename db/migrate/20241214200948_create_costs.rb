class CreateCosts < ActiveRecord::Migration[8.0]
  def change
    create_table :costs do |t|
      t.string :description
      t.decimal :amount, precision: 10, scale: 2
      t.date :date
      t.boolean :paid, default: true
      t.boolean :fixed, default: false
      t.timestamps
    end
  end
end
