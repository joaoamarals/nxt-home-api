# frozen_string_literal: true

class PopulateElementsJson < ActiveRecord::Migration[7.0]
  def up
    HomeAd.all.each do |home_ad|
      home_ad.elements_json = home_ad.elements
      home_ad.save
    end
  end

  def down
    HomeAd.all.each do |home_ad|
      home_ad.elements = home_ad.elements_json
      home_ad.save
    end
  end
end
