module ApplicationHelper

  def display_integer(number, options = { significant: false, precision: 2, delimiter: "'" })
    number_with_delimiter(number, options)
  end

  def monthly_views_per_countries_for_chart(monthly_views_per_countries, start_day, end_day)
    monthly_views_per_countries = _fill_missing_months(monthly_views_per_countries, start_day, end_day)

    monthly_views_per_country_names = {}
    monthly_views_per_countries.each do |country_key, monthly_views|
      if country = Country[country_key]
        monthly_views_per_country_names[country.name] = monthly_views
      end
    end

    Hash[monthly_views_per_country_names.sort { |a, b| b[1].sum <=> a[1].sum }.slice(0, 15)]
  end

  def monthly_views_per_subregions_for_chart(monthly_views_per_countries, start_day, end_day)
    monthly_views_per_countries = _fill_missing_months(monthly_views_per_countries, start_day, end_day)

    monthly_views_per_country_names = {}
    monthly_views_per_countries.each do |country_key, monthly_views|
      if country = Country[country_key]
        monthly_views_per_country_names[country.region] ||= []
        monthly_views.each_with_index do |v, i|
          monthly_views_per_country_names[country.region][i] ||= 0
          monthly_views_per_country_names[country.region][i]  += v
        end
      end
    end

    Hash[monthly_views_per_country_names.sort { |a, b| b[1].sum <=> a[1].sum }]
  end

  def views_per_month(chart_data)
    monthly_views ||= Hash.new(0)

    chart_data.map do |country_hash|
      country_hash[:data].each do |day, views|
        monthly_views[day] += views
      end
    end

    monthly_views
  end

  private

  def _fill_missing_months(monthly_views_per_countries, start_day, end_day)
    monthly_views_per_countries_with_missing_day_filled = {}

    monthly_views_per_countries.each do |country_key, monthly_views|
      day = start_day
      while day <= end_day
        monthly_views_per_countries_with_missing_day_filled[country_key] ||= []
        monthly_views_per_countries_with_missing_day_filled[country_key] << (monthly_views[day.to_date] || 0)
        day += 1.month
      end
    end

    monthly_views_per_countries_with_missing_day_filled
  end

end
