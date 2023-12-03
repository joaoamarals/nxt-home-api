class CreateSearches < ActiveRecord::Migration[7.0]
  def change
    create_table :searches do |t|
      t.string :location, null: false
      t.decimal :min_price
      t.decimal :max_price
      t.integer :rooms

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
