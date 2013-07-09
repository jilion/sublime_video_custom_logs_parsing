class DailyViewsPerCountry < ActiveRecord::Base

  validates :day, presence: true, uniqueness: true
  validates :lines_parsed, presence: true

  def initialize(*args)
    super
    self.lines_parsed ||= 0
    self.views_per_country ||= Hash.new(0)
  end

  def increment_views_for!(country_code)
    self.views_per_country = views_per_country.dup.tap { |views| views[country_code] = views[country_code].to_i + 1 }
    self.increment(:lines_parsed)
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
#  lines_parsed      :integer
#  updated_at        :datetime
#  views_per_country :hstore
#
# Indexes
#
#  index_daily_views_per_countries_on_day  (day) UNIQUE
#

