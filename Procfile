web: bundle exec puma -p $PORT
resque: env TERM_CHILD=1 RESQUE_TERM_TIMEOUT=10 COUNT=10 QUEUE=* bundle exec rake resque:workers
