# frozen_string_literal: true

class HomeAd < ApplicationRecord
  serialize :elements, HashSerializer
  store_accessor :elements, :link, :title, :features

  after_create do
    ActiveSupport::Notifications.instrument(
      'created.home_ad', { home_ad: self }
    )
  end

  def location
    elements[:link].split('/')[2]
  end

  def no_of_rooms
    features['number-of-rooms'].match(/[0-9]/)[0].to_i
  end

  def price
    (elements[:price].match(/[0-9,]+/) || [])[0]&.gsub(',', '').to_i
  end
end
