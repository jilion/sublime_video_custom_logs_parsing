require 'sidekiq'

class LogReaderWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'custom-logs'

  attr_accessor :start_at

  def perform(start_at)
    @start_at = Time.parse(start_at).change(sec: 0)
    _with_blocked_queue { _read_log_and_update_views_counter }
  end

  private

  def _with_blocked_queue
    Sidekiq::Queue['custom-logs'].block
    yield
    Sidekiq::Queue['custom-logs'].unblock
  end

  def _read_log_and_update_views_counter
    _gif_request_lines do |line|
      parsed_line = LogLineParser.new(line)

      if parsed_line.valid_start_request?
        views = DailyViewsPerCountry.find_or_initialize_by(day: start_at.to_date)
        views.increment_views_for!(parsed_line.country_code)
      end
    end
  end

  def _gif_request_lines
    _gzip_lines do |line|
      yield(line) if _gif_request?(line)
    end
  end

  def _gif_request?(line)
    line.include?('/_.gif')
  end

  def _gzip_lines
    _log_file do |tempfile|
      gz = Zlib::GzipReader.new(tempfile, encoding: 'iso-8859-1')
      gz.each_line { |line| yield(line) }
    end
  end

  def _log_file
    tempfile = Tempfile.new([File.basename(_log_filename), '.gz'])
    begin
      tempfile.write(_fog_file.body.encode!('UTF-8', 'UTF-8', invalid: :replace))
      tempfile.rewind
      yield(tempfile)
    ensure
      tempfile.close
      tempfile.unlink
    end
  end

  def _fog_file
    @_fog_file ||= S3Wrapper.fog_connection.get_object(S3Wrapper.bucket, _log_filename)
  end

  def _log_filename
    "voxcast/#{ENV['VOXCAST_HOSTNAME']}.log.#{start_at.to_i}-#{start_at.to_i + 60}.gz"
  end

end
