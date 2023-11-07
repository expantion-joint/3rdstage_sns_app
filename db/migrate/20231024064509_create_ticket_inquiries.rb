class CreateTicketInquiries < ActiveRecord::Migration[7.0]
  def change
    create_table :ticket_inquiries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post_ticket, null: false, foreign_key: true
      t.string :email
      t.string :subject
      t.text :message
      t.string :name
      t.string :contributor_email
      
      t.timestamps
    end
  end
end
