#!/bin/bash

# Install gems if necessary
ensure_gems()
{
  if [[ ! $(bundle check) ]]; then
    echo "Installing gems..."
    bundle install
  fi
}

# If the database exists, migrate. Otherwise setup (create and migrate)
run_migrations()
{
  bundle exec rake db:migrate
}

run_seeds()
{
  bundle exec rake db:seed
}

ensure_migrations()
{
  echo "Running migrations..."
  bundle exec rake db:migrate:with_data || (bundle exec rake db:create && run_migrations && run_seeds)
}

# Clean server PID if exists
ensure_process_id()
{
  server_pid=/code/tmp/pids/server.pid
  if [[ -f "$server_pid" ]]; then
    rm "$server_pid"
  fi
}

# Start web instance
start_web()
{
  ensure_gems
  ensure_migrations
  ensure_process_id

  # serve application
  bundle exec rails s -p $API_PORT -e development -b '0.0.0.0'
}

# Ensure sidekiq is installed before trying to run it
ensure_sidekiq()
{
  attempts=10
  waiting_time=2 # seconds
  increment=5    # seconds
  sidekiq_version=""

  # attempt to find sidekiq before running bundle
  for attempt in $(seq 1 $attempts); do
    echo "Attempt $attempt out of $attempts to run sidekiq"

    # sends stdout and stderr to grep and look for '* sidekiq (x.y.z)'
    # that means sidekiq gem is installed
    sidekiq_version=$(bundle info sidekiq \
      &> >(grep -oP '(?<=\* sidekiq \()(\d{1,2}\.){2}\d{1,2}'))

    # if string is not empty then sidekiq is installed, so leave loop
    if [[ -n "$sidekiq_version" ]]; then
      echo "Found sidekiq gem version $sidekiq_version."
      break
    fi

    # if no sidekiq is found, sleep and try again
    echo "Waiting $waiting_time seconds before next attempt..."
    sleep $waiting_time

    # increase five seconds for next attempt
    waiting_time=$(expr "$waiting_time" + "$increment")
  done

  # return 0 if sidekiq was found or 1 if not found
  if [[ -z "$sidekiq_version" ]]; then
    return 1
  else
    return 0
  fi
}
#
# Start worker instance
start_worker()
{
  ensure_gems
  ensure_sidekiq

  # evaluate return codes from previous function
  case "$?" in
    0)
      echo "Sidekiq was found. Starting process..."
      bundle exec sidekiq
      ;;
    1)
      echo "Sidekiq not found!"
      ;;
  esac
}

# Start instance based on instance type
case "$IS_WORKER" in
  "false")
    echo "Web instance detected."
    echo "Serving on ssl://0.0.0.0:$API_PORT with certificates from $ssl_folder"
    start_web
    ;;
  "true")
    echo "Worker instance detected."
    start_worker
    ;;
  *)
    echo "Startup script was not able to detect the instance type from docker-compose"
    echo "Environment Variable IS_WORKER has returned: $IS_WORKER"
    ;;
esac
