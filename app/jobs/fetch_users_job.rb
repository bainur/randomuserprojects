# app/jobs/fetch_users_job.rb
require 'net/http'

class FetchUsersJob < ApplicationJob
  def perform
    # fetch the datas from the API for 
    begin
      response = Net::HTTP.get_response(URI('https://randomuser.me/api/?results=20'))
      raise StandardError, 'API Error: Unexpected response' unless response.is_a?(Net::HTTPSuccess)

      data = JSON.parse(response.body)['results']
      raise StandardError, 'API Error: Response structure changed' unless data.is_a?(Array)

      data.each do |user_data|
        user = User.find_or_initialize_by(uuid: user_data['login']['uuid'])
        user.name = user_data["name"]
        user.age = user_data['dob']['age']
        user.gender = user_data['gender']
        user.location = user_data["location"]
        user.save
      end
    rescue StandardError => e
      # Log the error or perform any necessary error handling
      Rails.logger.error("Error fetching user data from API: #{e.message}")
    end
  end
end
