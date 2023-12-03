# frozen_string_literal: true

class HomeAd < ApplicationRecord
  serialize :elements, Hash

  after_commit do
    ActiveSupport::Notifications.instrument(
      'created.home_ad', { home_ad: self }
    )
  end

  def location
    elements[:link].split('/')[2]
  end

  def no_of_rooms
    elements[:features]['number-of-rooms'].match(/[0-9]/)[0]
  end

  def price
    elements[:price].match(/[0-9]+/)[0].to_i
  end

end
