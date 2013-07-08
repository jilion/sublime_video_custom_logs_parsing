require 'geoip'

class GeoIPWrapper

  def self.country(ip)
    result = _database.country(ip).country_code2.downcase
    _handle_edge_case(result)
  rescue
    nil
  end

  private

  def self._database
    @database ||= GeoIP.new(_database_url)
  end

  def self._database_url
    Rails.root.join('vendor', 'geoip.dat')
  end

  def self._handle_edge_case(result)
    case result
    when 'gb' then 'uk'
    when '--' then nil
    else result
    end
  end

end

