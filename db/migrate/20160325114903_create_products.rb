class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.string :url
      t.float :price
      t.string :sku

      t.timestamps null: false
    end
  end
end
