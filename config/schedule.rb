cron "*/30 * * * *", as: "CleanOrphanAttachmentsJob", timeout: "60s", overlap: false do
  GetNewAdsJob.perform_later
end
