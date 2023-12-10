# frozen_string_literal: true

host = ENV['REDIS_HOST'] || 'localhost'
port = ENV['REDIS_PORT'] || '6379'
db = ENV['SIDEKIQ_REDIS_DB'] || '4'
password = ENV['REDIS_PASSWORD']
use_ssl = Rails.env.production? || Rails.env.staging?

Sidekiq.configure_server do |config|
  config.redis = {
    host: host, port: port, ssl: use_ssl,
    password: password, db: db
  }
end


Sidekiq.configure_client do |config|
  config.redis = {
    host: host, port: port, ssl: use_ssl,
    password: password, db: db
  }
end
