## SublimeVideo logs parsing for geographic analysis

Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.

## Requirements

### Redis

* Connections: ~50 for 900 threads
* RAM: ~15MB

=> [100MB plan is enough](https://addons.heroku.com/rediscloud)

### Postgres

* Connections: ~10
* 1 row per day: 10,000 rows ~= 27 years!

=> [Dev plan is enough](https://addons.heroku.com/heroku-postgresql)

### Workers

### worker

This type of worker is used to parse the log files, you can easily scale them
up to 20.

### db_worker

This type of worker is exclusively dedicated to access the Postgres DB in a
sequential fashion to ensure no race conditions. Its Sidekiq concurrency is
set to 1. *You must scale it to 1 and no more!!*

## Deployment

```bash
gp production
```

## Launch some parsing

### Parse a day

```bash
h run rake 'logs:parse_for_day[2013,3,1]'
```

Note: This clear all the stats for the given day before starting the parsing.

### Parse a month

```bash
h run rake 'logs:parse_for_year_and_month[2013,3]'
```

Note: This clear all the stats for the given month before starting the parsing.

### Parse the current month

```bash
h run rake 'logs:parse_for_year_and_month[2013,3]'
```

Note: This clear all the stats for the current month before starting the parsing.

## Scaling

To enable workers:

```bash
hs worker=6 db_worker=1
```

To disable workers:

```bash
hs worker=0 db_worker=0
```
