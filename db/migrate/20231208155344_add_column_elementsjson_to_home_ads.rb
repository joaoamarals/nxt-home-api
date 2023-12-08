class AddColumnElementsjsonToHomeAds < ActiveRecord::Migration[7.0]
  def change
    add_column :home_ads, :elements_json, :jsonb, after: :elements
  end
end
