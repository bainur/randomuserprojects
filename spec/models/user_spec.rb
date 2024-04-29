# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
    let(:user) { create(:user) }
  describe '#retabulate_daily' do
    

    it 'decrements gender counts in Redis and triggers TabulateDailyRecordsJob' do
      expect(Redis.current).to receive(:hincrby).with('gender_counts', 'male', -1)
      expect(TabulateDailyRecordsJob).to receive(:perform_now)

      user.destroy
    end

    it 'does not decrement Redis counts for female users' do
      female_user = create(:user, gender: 'female')

      expect(Redis.current).not_to receive(:hincrby)

      female_user.destroy
    end
  end
end
