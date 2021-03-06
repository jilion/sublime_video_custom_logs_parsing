require 'sidekiq'

class LogReaderWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'custom-logs'

  def perform(start_at)
    @start_at = Time.parse(start_at).change(sec: 0)

    _read_log_and_update_views_counter
  end

  private

  def _read_log_and_update_views_counter
    views_per_country = Hash.new(0)

    _gzip_lines do |line|
      parsed_line = LogLineParser.new(line)

      if parsed_line.valid_start_request?
        views_per_country[parsed_line.country_code] += 1
      end
    end

    DatabaseUpdaterWorker.perform_async(@start_at, views_per_country)
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
    "voxcast/#{ENV['VOXCAST_HOSTNAME']}.log.#{@start_at.to_i}-#{@start_at.to_i + 60}.gz"
  end

end
