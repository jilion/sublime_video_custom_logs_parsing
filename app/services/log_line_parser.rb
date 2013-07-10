require 'multi_json'
require 'cgi'
require 'geoip_wrapper'

class LogLineParser

  REGEX = %r{^
    (\d+|\-)\s # cache_miss_reason
    (\d+|\-)\s # cache_status
    (\S*)\s    # client ip
  }x

  attr_accessor :line

  def initialize(line)
    @line = line
  end

  def ip
    _scan[2]
  end

  def country_code
    GeoIPWrapper.country(ip)
  end

  def valid_start_request?
    @valid_start_request ||= gif_request? && get_request? && start_event?
  end

  def gif_request?
    line.include?('/_.gif')
  end

  def get_request?
    line.include?(' GET ')
  end

  def start_event?
    line =~ /[\?&]?e=s&?/
  end

  private

  def _scan
    @_scan ||= line.scan(REGEX).flatten
  end

end
