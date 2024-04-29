# app/jobs/fetch_users_job.rb
require 'net/http'

class FetchUsersJob < ApplicationJob
  def perform
    # fetch the datas from the API for generating user each 1 hour, stored in sideqik scheduler
    begin
      new_records = [] # each api will insert 20 rows in one run


      while  new_records.size < 20
        response = Net::HTTP.get_response(URI('https://randomuser.me/api/?results=20'))
        raise StandardError, 'API Error: Unexpected response' unless response.is_a?(Net::HTTPSuccess)

        data = JSON.parse(response.body)['results']
        raise StandardError, 'API Error: Response structure changed' unless data.is_a?(Array)
        male_count = 0
        female_count = 0

        data.each do |user_data|
          user = User.find_or_initialize_by(uuid: user_data['login']['uuid'])
          user_attr = {
            uuid: user_data['login']['uuid'],
            name: user_data["name"],
            age: user_data['dob']['age'],
            gender: user_data['gender'],
            location: user_data['location']
          }
          if user.persisted?
            user.update(user_attr)  
          else
            new_records << user_attr
            # stored counter to save on redis only the new records
            user_data['gender'] == "male" ? male_count += 1 : female_count += 1
          end          
        end
        User.upsert_all(new_records) 
        update_gender_counts(male_count, female_count)
      end
    rescue StandardError => e
      # Log the error or perform any necessary error handling
      Rails.logger.error("Error fetching user data from API: #{e.message}")
    end
  end

  private

  def update_gender_counts(male_count, female_count)
    Redis.current.hincrby('gender_counts', 'male', male_count)
    Redis.current.hincrby('gender_counts', 'female', female_count)
  end

end
