class CreateInquiries < ActiveRecord::Migration[7.0]
  def change
    create_table :inquiries do |t|
      t.references :user, null: false, foreign_key: true
      t.string :email
      t.string :subject
      t.text :message
      t.string :name

      t.timestamps
    end
  end
end
