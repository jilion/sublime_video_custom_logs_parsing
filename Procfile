web:    bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: bundle exec sidekiq -c $SIDEKIQ_CONCURRENCY -q custom-logs -q custom-logs-parser,100
