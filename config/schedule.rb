cron "*/10 * * * *", as: "GetNewAdsJob", timeout: "60s", overlap: false do
  GetNewAdsJob.perform_later
end
