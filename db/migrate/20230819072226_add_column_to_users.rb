class AddColumnToUsers < ActiveRecord::Migration[7.0]
  def change

    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :display_name, :string
    add_column :users, :postcode, :integer
    add_column :users, :prefecture_code, :integer
    add_column :users, :address_city, :string
    add_column :users, :address_street, :string
    add_column :users, :address_building, :string
    add_column :users, :birthday, :date
    add_column :users, :contributor_code, :integer
    add_column :users, :contributor_name, :string
    add_column :users, :contributor_festival, :string
    add_column :users, :contributor_introduction, :text
      
  end
end
