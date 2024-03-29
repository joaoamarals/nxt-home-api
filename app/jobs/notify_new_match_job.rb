# frozen_string_literal: true

class NotifyNewMatchJob < ApplicationJob
  queue_as :default

  def perform(home_ad)
    match_searches = Search.where(location: home_ad.location,
                                  rooms: home_ad.no_of_rooms)
                           .where('min_price <= :price AND :price <= max_price', price: home_ad.price)

    match_searches.each do |search|
      # SearchMailer.with({ search:, home_ad: }).new_match.deliver_now
    end
  end
end
