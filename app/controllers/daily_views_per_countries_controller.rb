class DailyViewsPerCountriesController < ApplicationController
  def index
    @start_day = Time.utc(2013, 1).to_date
    @end_day   = Time.now.utc.to_date
    @daily_views_per_countries = DailyViewsPerCountry.monthly_views_per_countries(@start_day, @end_day)
  end
end
