Rails.application.config.after_initialize do
  ActiveSupport::Notifications.subscribe 'created.home_ad' do |event|
    NotifyNewMatchJob.perform_later(event.payload[:home_ad])
  end
end
