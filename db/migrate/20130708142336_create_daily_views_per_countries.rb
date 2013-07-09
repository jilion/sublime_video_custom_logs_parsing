class CreateDailyViewsPerCountries < ActiveRecord::Migration
  def up
    enable_extension 'hstore'
    create_table :daily_views_per_countries do |t|
      t.date :day
      t.hstore :views_per_country
      t.integer :lines_parsed

      t.timestamps
    end
    add_index :daily_views_per_countries, :day, :unique
  end

  def down
    disable_extension 'hstore'
    drop_table :daily_views_per_countries
  end
end
