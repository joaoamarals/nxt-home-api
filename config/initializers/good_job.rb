Rails.application.configure do
  config.good_job = {
    preserve_job_records: true,
    retry_on_unhandled_error: false,
    on_thread_error: -> (exception) { Rails.error.report(exception) },
    execution_mode: :async,
    queues: '*',
    max_threads: 5,
    poll_interval: 30,
    shutdown_timeout: 25,
    enable_cron: true,
    cron: {
      example: {
        cron: '*/10 * * * *',
        class: 'GetNewAdsJob'
      },
    },
    dashboard_default_locale: :en,
  }
end
