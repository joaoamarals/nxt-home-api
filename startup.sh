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

# Ensure good_job is installed before trying to run it
ensure_good_job()
{
  attempts=10
  waiting_time=2 # seconds
  increment=5    # seconds
  good_job_version=""

  # attempt to find good_job before running bundle
  for attempt in $(seq 1 $attempts); do
    echo "Attempt $attempt out of $attempts to run good_job"

    # sends stdout and stderr to grep and look for '* good_job (x.y.z)'
    # that means good_job gem is installed
    good_job_version=$(bundle info good_job\
      &> >(grep -oP '(?<=\* good_job \()(\d{1,2}\.){2}\d{1,2}'))

    # if string is not empty then good_job is installed, so leave loop
    if [[ -n "$good_job_version" ]]; then
      echo "Found good_job gem version $good_job_version."
      break
    fi

    # if no good_job is found, sleep and try again
    echo "Waiting $waiting_time seconds before next attempt..."
    sleep $waiting_time

    # increase five seconds for next attempt
    waiting_time=$(expr "$waiting_time" + "$increment")
  done

  # return 0 if good_job was found or 1 if not found
  if [[ -z "$good_job_version" ]]; then
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
  ensure_good_job

  # evaluate return codes from previous function
  case "$?" in
    0)
      echo "GoodJob was found. Starting process..."
      bundle exec good_job start
      ;;
    1)
      echo "GoodJob not found!"
      ;;
  esac
}

# Start instance based on instance type
case "$TYPE" in
  "web")
    echo "Web instance detected."
    echo "Serving on ssl://0.0.0.0:$API_PORT with certificates from $ssl_folder"
    start_web
    ;;
  "worker")
    echo "Worker instance detected."
    start_worker
    ;;
  *)
    echo "Startup script was not able to detect the instance type from docker-compose"
    echo "Environment Variable TYPE has returned: $TYPE"
    ;;
esac
