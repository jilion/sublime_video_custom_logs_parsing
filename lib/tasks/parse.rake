namespace :logs do

  desc 'Parse logs from the beginning of the current month '
  task parse: :environment do
    timestamp = Time.now.utc.beginning_of_month
    minutes_delayed = 0

    while timestamp <= Time.now.utc
      LogReaderWorker.perform_async(timestamp)
      timestamp += 60.seconds
      minutes_delayed += 1
    end
    puts "Delayed logs parsing from #{ime.now.utc.beginning_of_month} (#{minutes_delayed} minutes)"
  end

end
