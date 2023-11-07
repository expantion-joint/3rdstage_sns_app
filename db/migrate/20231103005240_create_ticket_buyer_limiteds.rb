class CreateTicketBuyerLimiteds < ActiveRecord::Migration[7.0]
  def change
    create_table :ticket_buyer_limiteds do |t|
      t.references :post_ticket, null: false, foreign_key: true
      t.datetime :set_time
      t.string :set_location
      t.string :suspension
      t.text :message
      t.text :contact_address

      t.timestamps
    end
  end
end
