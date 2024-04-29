# app/models/user.rb
class User < ApplicationRecord
  validates :uuid, presence: true, uniqueness: true
  validates :gender, presence: true, inclusion: { in: %w[male female] }

  # ensures that the job is triggered after the transaction is committed to the database
  after_commit :retabulate_daily, on: [:destroy]
  
  # if user delete row, recalculate ther report
  def retabulate_daily
    decrement_redis_counts
    TabulateDailyRecordsJob.perform_now
  end

  private

  def decrement_redis_counts
    # decrement the redis first. before update tabulation
    if gender == 'male'
      Redis.current.hincrby('gender_counts', 'male', -1)
    else
      Redis.current.hincrby('gender_counts', 'female', -1)
    end
  end
end