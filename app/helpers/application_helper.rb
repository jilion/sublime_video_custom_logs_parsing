module ApplicationHelper

  def display_integer(number, options = { significant: false, precision: 2, delimiter: "'" })
    number_with_delimiter(number, options)
  end

  def monthly_views_total_for_chart(monthly_views_per_countries, start_day, end_day)
    _monthly_views_total(monthly_views_per_countries, start_day, end_day)
  end

  def monthly_views_per_country_for_chart(monthly_views_per_countries, start_day, end_day)
    Hash[_monthly_views_per_country(monthly_views_per_countries, start_day, end_day).sort { |a, b| b[1].sum <=> a[1].sum }.slice(0, 25)]
  end

  def monthly_views_per_region_for_chart(monthly_views_per_countries, start_day, end_day)
    Hash[_monthly_views_per_region(monthly_views_per_countries, start_day, end_day).sort { |a, b| b[1].sum <=> a[1].sum }]
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

  def _monthly_views_total(monthly_views_per_countries, start_day, end_day)
    day = start_day
    monthly_views = Hash.new(0)
    while day <= end_day
      monthly_views[day] += monthly_views_per_countries.sum { |country_key, hash| hash[day] }
      day += 1.month
    end

    { Total: monthly_views.values }
  end

  def _monthly_views_per_country(monthly_views_per_countries, start_day, end_day)
    monthly_views_per_country = {}
    _fill_missing_months(monthly_views_per_countries, start_day, end_day).each do |country_key, monthly_views|
      _group_by_country(monthly_views_per_country, country_key, monthly_views)
    end

    monthly_views_per_country
  end

  def _monthly_views_per_region(monthly_views_per_countries, start_day, end_day)
    monthly_views_per_region = {}
    _fill_missing_months(monthly_views_per_countries, start_day, end_day).each do |country_key, monthly_views|
      _group_by_region(monthly_views_per_region, country_key, monthly_views)
    end

    monthly_views_per_region
  end

  def _group_by_country(monthly_views_per_country, country_key, monthly_views)
    if country = Country[country_key]
      monthly_views_per_country[country.name] = monthly_views
    end
  end

  def _group_by_region(monthly_views_per_region, country_key, monthly_views)
    if country = Country[country_key]
      monthly_views_per_region[country.region] ||= []
      monthly_views.each_with_index do |v, i|
        monthly_views_per_region[country.region][i] ||= 0
        monthly_views_per_region[country.region][i]  += v
      end
    end
  end

end
