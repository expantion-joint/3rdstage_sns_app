class AddBankToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :financial_institution, :string
    add_column :users, :branch_name, :string
    add_column :users, :deposit_type, :string
    add_column :users, :account_number, :string
    add_column :users, :account_name, :string
  end
end
