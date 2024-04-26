# app/jobs/tabulate_daily_records_job.rb
class TabulateDailyRecordsJob < ApplicationJob
  def perform
    # count each user based on gender first
    male_count = Redis.current.hget('gender_counts', 'male')
    female_count = Redis.current.hget('gender_counts', 'female')

    # find or update the daily record so daily record will have only 1 row per day
    daily_record = DailyRecord.find_or_initialize_by(date_fetched: Date.today)
    
    daily_record.male_count = male_count
    daily_record.female_count = female_count
    daily_record.save    
  end
end
