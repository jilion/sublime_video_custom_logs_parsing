class DailyViewsPerCountriesController < ApplicationController
  def index
    @monthly_views_per_countries = DailyViewsPerCountry.monthly_views_per_countries
  end
end
