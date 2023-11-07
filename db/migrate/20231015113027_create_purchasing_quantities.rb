class CreatePurchasingQuantities < ActiveRecord::Migration[7.0]
  def change
    create_table :purchasing_quantities do |t|
      t.references :post_ticket, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :count
      t.string :payment_history

      t.timestamps
    end
  end
end
