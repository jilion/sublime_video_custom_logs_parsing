namespace :logs do

  desc 'Parse logs from the beginning of the current month'
  task parse_for_current_month: :environment do
    timestamp = Time.now.utc.beginning_of_month
    minutes_delayed = 0
    DailyViewsPerCountry.where(day: (timestamp..Time.now.utc)).delete_all

    while timestamp <= Time.now.utc
      LogReaderWorker.perform_async(timestamp)
      timestamp += 60.seconds
      minutes_delayed += 1
    end
    puts "Delayed logs parsing from #{Time.now.utc.beginning_of_month} to #{timestamp} (#{minutes_delayed} minutes, ~#{minutes_delayed/60/24.to_f} days)"
  end

end
