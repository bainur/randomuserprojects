# app/models/user.rb
class User < ApplicationRecord
  validates :uuid, presence: true, uniqueness: true
  validates :gender, presence: true, inclusion: { in: %w[male female] }

  # ensures that the job is triggered after the transaction is committed to the database
  after_commit :update_daily_record, on: [:create, :destroy]

  def update_daily_record
    # update the daily record table for repopulate the data and result of avg, and count
    TabulateDailyRecordsJob.perform_now
  end
end