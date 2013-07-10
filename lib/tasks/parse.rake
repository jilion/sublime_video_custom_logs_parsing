namespace :logs do

  desc 'Parse logs from the beginning of the current month'
  task parse_for_current_month: :environment do |t, args|
    delay_parsing_for_period(Time.now.utc.beginning_of_month, Time.now.utc)
  end

  desc "Parse logs for the month of year/month given.  e.g.: rake 'logs:parse_for_year_and_month[2013,2]'"
  task :parse_for_year_and_month, [:year, :month] => [:environment] do |t, args|
    date = Time.utc(args.year, args.month)
    delay_parsing_for_period(date.beginning_of_month, date.end_of_month)
  end

end

def delay_parsing_for_period(start_at, end_at)
    DailyViewsPerCountry.where(day: (start_at..end_at)).delete_all

    minutes_to_delay = ((end_at - start_at) / 60).to_i
    minutes_delayed = 0
    timestamp = start_at

    while timestamp <= end_at
      minutes_delayed += 1
      LogReaderWorker.perform_async(timestamp)
      timestamp += 60.seconds
      puts "Delayed #{minutes_delayed} / #{minutes_to_delay} minutes" if minutes_delayed % 1000 == 0
    end
    puts "Delayed logs parsing from #{start_at} to #{timestamp} (#{minutes_delayed} minutes, ~#{minutes_delayed/60/24} days)"
end
