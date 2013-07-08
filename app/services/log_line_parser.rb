require 'multi_json'
require 'cgi'
require 'geoip_wrapper'

class LogLineParser

  REGEX = %r{^
    (\d*)\s  # timestamp
    (\d*)\s  # time_taken
    (\S*)\s  # client ip
    (\S*)\s  # filesize
    (\S*)\s  # server ip
    (\d*)\s  # port
    (\S*)\s  # status
    (\d*)\s  # response bytes
    (\S*)\s  # method
    (\S*)\s  # uri-stem
    -\s  # uri-query
    (\d*)\s  # duration
    (\d*)\s  # request bytes
    "(.*)"\s # referrer
    "(.*)"\s # user agent
    (\S*)    # customer id
  }x

  attr_accessor :line

  def initialize(line)
    @line = line
  end

  def timestamp
    Time.at(_scan[0].to_i)
  end

  def ip
    _scan[2]
  end

  def country_code
    GeoIPWrapper.country(ip)
  end

  def status
    _scan[6].split('/').last.to_i
  end

  def method
    _scan[8]
  end

  def uri_stem
    _scan[9]
  end

  def user_agent
    _scan[13]
  end

  def start_request?
    @start_request ||= uri_stem.include?('/_.gif') && method == 'GET' && start_event?
  end

  def start_event?
    _params.key?('e') && _params['e'].first == 's'
  end

  private

  def _params
    @_params ||= CGI::parse(uri_stem)
  end

  def _scan
    @_scan ||= line.scan(REGEX).flatten
  end

end
