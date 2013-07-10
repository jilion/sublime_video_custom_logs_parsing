Sidekiq.configure_server do |config|
  if database_url = ENV['DATABASE_URL']
    ENV['DATABASE_URL'] = "#{database_url}?pool=#{ENV['SIDEKIQ_CONCURRENCY']}"
    ActiveRecord::Base.establish_connection
  end
end

Sidekiq.configure_client do |config|
  config.redis = { size: 2 } # for web dyno
end

Sidekiq::Queue['custom-logs-db-updater'].limit = 1 # this update a record in the DB so ensure no race condition!
