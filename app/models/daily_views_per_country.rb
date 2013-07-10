class DailyViewsPerCountry < ActiveRecord::Base

  validates :day, presence: true, uniqueness: true

  def initialize(*args)
    super
    self.views_per_country ||= Hash.new(0)
  end

  def self.monthly_views_per_countries(start_date, end_date = Time.now.utc)
    start_day, end_day = start_date.to_date, end_date.to_date
    monthly_views_per_countries ||= Hash.new { |hash, country| hash[country] = Hash.new(0) }

    DailyViewsPerCountry.where(day: (start_day..end_day)).order(:day).all.each do |daily_views_per_country|
      daily_views_per_country.views_per_country.each do |country_key, views|
        monthly_views_per_countries[country_key][daily_views_per_country.day.beginning_of_month.to_date] += views.to_i
      end
    end

    monthly_views_per_countries
  end

  def increment_views!(new_views_per_country)
    current_views_per_country = views_per_country.dup
    new_views_per_country.each do |k, v|
      current_views_per_country[k] = current_views_per_country[k].to_i + v
    end
    self.views_per_country = current_views_per_country
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

