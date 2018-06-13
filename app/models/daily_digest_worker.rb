# This is not used anywhere, but I want to keep this code for reference.
class DailyDigestWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily(1) }

  def perform
    # User.send_daily_digest
  end
end
