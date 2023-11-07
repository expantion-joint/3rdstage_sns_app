class CreatePostTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :post_tickets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :festival_name
      t.string :event_name
      t.string :category
      t.text :content
      t.date :event_date
      t.integer :count
      t.integer :price
      t.string :venue
      t.integer :purchasing_quantities
      t.string :unit

      t.timestamps
    end
  end
end
