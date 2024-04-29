# spec/jobs/tabulate_daily_records_job_spec.rb
require 'rails_helper'

RSpec.describe TabulateDailyRecordsJob, type: :job do
  describe '#perform' do
    it 'updates existing daily record if it exists' do
      DailyRecord.create(date_fetched: Date.today, male_count: 5, female_count: 3)
      
      allow(Redis.current).to receive(:hget).with('gender_counts', 'female').and_return('9')
      allow(Redis.current).to receive(:hget).with('gender_counts', 'male').and_return('11')

      expect do
        described_class.perform_now
      end.to_not change { DailyRecord.count }

      daily_record = DailyRecord.last
      expect(daily_record.date_fetched).to eq(Date.today)
      expect(daily_record.male_count).to eq(11)
      expect(daily_record.female_count).to eq(9)
    end
  end
end
