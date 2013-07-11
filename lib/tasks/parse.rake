namespace :logs do

  desc 'Parse logs from the beginning of the current month'
  task parse_for_current_month: :environment do
    LogParserDelayerWorker.perform_async(Time.now.utc.beginning_of_month, Time.now.utc)
  end

  desc "Parse logs for the month of year/month given.  e.g.: rake 'logs:parse_for_year_and_month[2013,2]'"
  task :parse_for_year_and_month, [:year, :month] => [:environment] do |t, args|
    date = Time.utc(args.year, args.month)

    LogParserDelayerWorker.perform_async(date.beginning_of_month, date.end_of_month)
  end

  desc 'Parse logs from a specific day'
  task :parse_for_day, [:year, :month, :day] => [:environment] do |t, args|
    date = Time.utc(args.year, args.month, args.day)

    LogParserDelayerWorker.perform_async(date.beginning_of_day, date.end_of_day)
  end

end
