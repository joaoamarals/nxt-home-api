Rails.application.config.after_initialize do
  ActiveSupport::Notifications.subscribe 'created.home_ad' do |event|
    puts 'Sending email to users...'
    puts event.payload[:home_ad]
    NotifyNewMatchJob.perform_later(event.payload[:home_ad])
  end
end
