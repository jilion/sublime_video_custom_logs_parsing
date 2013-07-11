class MonthlyViewsController < ApplicationController
  before_filter :_set_dates, :_find_views

  def index
  end

  def country
  end

  def region
  end

  private

  def _set_dates
    @start_day = Time.utc(2013, 1).to_date
    @end_day   = Time.now.utc.to_date
  end

  def _find_views
    @monthly_views_per_countries = DailyViewsPerCountry.monthly_views_per_countries(@start_day, @end_day)
  end
end
