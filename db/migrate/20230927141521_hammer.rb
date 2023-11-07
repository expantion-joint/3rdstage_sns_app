class Hammer < ActiveRecord::Migration[7.0]
  def change
    add_reference :hammers, :user, foreign_key: true
    add_reference :hammers, :post, foreign_key: true
    add_column :hammers, :payment_history, :string
  end
end
