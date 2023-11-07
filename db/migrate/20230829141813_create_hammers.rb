class CreateHammers < ActiveRecord::Migration[7.0]
  def change
    create_table :hammers do |t|
      t.references :bid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
