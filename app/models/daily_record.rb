# app/models/daily_record.rb
class DailyRecord < ApplicationRecord
  validates :date_fetched, presence: true
  validates :male_count, :female_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :male_avg_age, :female_avg_age, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  
  before_save :calculate_average_ages, if: :male_count_changed? || :female_count_changed?

  def calculate_average_ages
    # averaging in one query based on gender
    averages = User.group(:gender).average(:age)

    self.male_avg_age = averages['male']
    self.female_avg_age = averages['female']
  end
end

