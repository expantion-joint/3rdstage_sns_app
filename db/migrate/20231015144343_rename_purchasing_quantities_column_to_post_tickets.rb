class RenamePurchasingQuantitiesColumnToPostTickets < ActiveRecord::Migration[7.0]
  def change
    rename_column :post_tickets, :purchasing_quantities, :total_purchases
  end
end
