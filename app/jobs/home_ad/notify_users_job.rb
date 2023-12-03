# frozen_string_literal: true

module HomeAd
  class NotifyUsersJob < ApplicationJob
    queue_as :default

    def perform(home_ad)
      match_searches = Search.where(location: home_ad.location,
                                    rooms: home_ad.no_of_rooms)
                             .where('min_price <= ? <= max_price', home_ad.price)

      match_searches.each do |search|
        SearchMailer.with({ search:, home_ad: }).new_match.deliver_now
      end
    end
  end
end
