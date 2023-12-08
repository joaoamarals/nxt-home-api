class ChangeElementsJsonToElements < ActiveRecord::Migration[7.0]
  def change
    remove_column :home_ads, :elements, :text, after: :uuid
    rename_column :home_ads, :elements_json, :elements
  end
end
