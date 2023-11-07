class CreateSuccessfulBidderLimiteds < ActiveRecord::Migration[7.0]
  def change
    create_table :successful_bidder_limiteds do |t|
      t.references :post, null: false, foreign_key: true
      t.datetime :set_time
      t.string :set_location
      t.string :suspension
      t.text :message
      t.string :contact_address

      t.timestamps
    end
  end
end
