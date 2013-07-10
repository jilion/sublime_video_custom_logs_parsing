class DailyViewsPerCountry < ActiveRecord::Base

  validates :day, presence: true, uniqueness: true

  def initialize(*args)
    super
    self.views_per_country ||= Hash.new(0)
  end

  def self.monthly_views_per_countries
    monthly_views_per_countries ||= Hash.new { |hash, country| hash[country] = Hash.new(0) }

    DailyViewsPerCountry.find_each do |daily_views_per_country|
      daily_views_per_country.views_per_country.each do |country_key, views|
        if country = Country[country_key]
          monthly_views_per_countries[country.name][daily_views_per_country.day.beginning_of_month] += views.to_i
        end
      end
    end

    monthly_views_per_countries.map { |k, v| { name: k, data: v } }.sort { |a, b| b[:data].sum { |k, v| v } <=> a[:data].sum { |k, v| v } }.shift(25)
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

