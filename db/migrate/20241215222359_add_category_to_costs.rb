class AddCategoryToCosts < ActiveRecord::Migration[8.0]
  def change
    add_column :costs, :category_id, :integer
  end
end
