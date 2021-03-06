require 'sidekiq'

class DatabaseUpdaterWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'db-updater'

  def perform(timestamp, increments)
    timestamp = Time.parse(timestamp).to_date

    DailyViewsPerCountry.find_or_initialize_by(day: timestamp.to_date).increment_views!(increments)
  end
end
