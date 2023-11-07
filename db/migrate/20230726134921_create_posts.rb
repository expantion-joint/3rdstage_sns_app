class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :festival_name
      t.string :event_name
      t.string :category
      t.text :content
      t.date :event_date
      t.string :venue
      t.datetime :start_time
      t.datetime :end_time
      t.integer :start_price
      t.integer :count

      t.timestamps
    end
  end
end
