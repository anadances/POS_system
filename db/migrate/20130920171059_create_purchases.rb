class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :product_id
      t.integer :quantity
      t.integer :sale_id

      t.timestamps
    end
  end
end
