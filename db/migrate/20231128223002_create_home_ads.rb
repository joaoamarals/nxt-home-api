class CreateHomeAds < ActiveRecord::Migration[7.0]
  def change
    create_table :home_ads do |t|
      t.string :uuid
      t.text :elements
      t.index :uuid, unique: true

      t.timestamps
    end
  end
end
