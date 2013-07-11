require 'sidekiq'

class LogParserDelayerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'custom-logs'

  def perform(start_at, end_at)
    @start_at = Time.parse(start_at)
    @end_at   = Time.parse(end_at)

    DailyViewsPerCountry.where(day: (@start_at..@end_at)).delete_all

    minutes_to_delay = ((@end_at - @start_at) / 60).to_i
    minutes_delayed = 0
    timestamp = @start_at

    while timestamp <= @end_at
      minutes_delayed += 1
      LogReaderWorker.perform_async(timestamp)
      timestamp += 60.seconds
    end
    logger.info "Delayed logs parsing from #{@start_at} to #{timestamp} (#{minutes_delayed} minutes, ~#{minutes_delayed/60/24} days)"
  end

end
