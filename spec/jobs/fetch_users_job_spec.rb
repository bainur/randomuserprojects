# spec/jobs/fetch_users_job_spec.rb
require 'rails_helper'

RSpec.describe FetchUsersJob, type: :job do
  describe '#perform' do
    let(:api_response) do
      File.read(Rails.root.join('spec', 'mock_files', 'fetch_users_job.json'))
    end

    before do
      allow(Net::HTTP).to receive(:get_response).and_return(double(body: api_response, is_a?: Net::HTTPSuccess))
    end

    it 'fetches users from API and stores them in the database' do
      expect do
        described_class.perform_now
      end.to change(User, :count).by(20)

      expect(User.last(20).pluck(:uuid)).to all(be_present)
    end

    it 'updates gender counts in Redis' do
      expect(Redis.current).to receive(:hincrby).with('gender_counts', 'male', 11)
      expect(Redis.current).to receive(:hincrby).with('gender_counts', 'female', 9)

      described_class.perform_now
    end
  end
end
