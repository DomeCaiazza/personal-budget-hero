class AddTypeToCategoty < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :category_type, :integer, default: 0
  end
end
