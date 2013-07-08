require 'zlib'
require 'sidekiq'

class LogLineParserWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'custom-logs-parser'

  attr_accessor :parsed_line

  def perform(line)
    @parsed_line = LogLineParser.new(line)
    return unless parsed_line.start_request?

    views = DailyViewsPerCountry.find_or_initialize_by(day: parsed_line.timestamp.to_date)
    views.increment_views_for!(parsed_line.country_code)
  end
end
