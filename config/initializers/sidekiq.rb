# frozen_string_literal: true

settings = Settings.sidekiq

connection = proc do
  Redis.new(
    host: settings.redis.host,
    port: settings.redis.port
  )
end

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: settings.client.pool, &connection)
end

Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: settings.server.pool, &connection)
end
