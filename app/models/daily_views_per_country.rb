class DailyViewsPerCountry < ActiveRecord::Base

  validates :day, presence: true, uniqueness: true
  validates :minutes_parsed, presence: true

  def initialize(*args)
    super
    self.minutes_parsed ||= 0
    self.views_per_country ||= Hash.new(0)
  end

  def increment_views_for!(country_code)
    self.views_per_country = views_per_country.dup.tap { |views| views[country_code] = views[country_code].to_i + 1 }
    self.minutes_parsed += 1
    self.save!
  end

end

# == Schema Information
#
# Table name: daily_views_per_countries
#
#  created_at        :datetime
#  day               :date
#  id                :integer          not null, primary key
#  minutes_parsed    :integer
#  updated_at        :datetime
#  views_per_country :hstore
#
# Indexes
#
#  index_daily_views_per_countries_on_day  (day) UNIQUE
#

