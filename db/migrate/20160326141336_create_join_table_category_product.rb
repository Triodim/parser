class CreateJoinTableCategoryProduct < ActiveRecord::Migration
  def change
    create_join_table :categories, :products
  end
end
