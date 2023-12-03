# frozen_string_literal: true

ActiveSupport::Notifications.subscribe 'created.home_ad' do |event|
  HomeAd::NotifyUsersJob.perform_later(event.payload[:home_ad])
end
