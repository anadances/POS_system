class CreateCashiers < ActiveRecord::Migration
  def change
    create_table :cashiers do |t|
      t.string :name

      t.timestamps
    end
  end
end
