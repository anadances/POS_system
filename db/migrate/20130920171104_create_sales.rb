class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :cashier_id
      t.timestamps
    end
  end
end
