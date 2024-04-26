# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

#reset codes
User.delete_all
DailyRecord.delete_all
Redis.current.hdel('gender_counts', 'male')
Redis.current.hdel('gender_counts', 'female')

# get the redis
Redis.current.hget('gender_counts', 'female')
Redis.current.hget('gender_counts', 'male')


# run again
3.times do |x|
 FetchUsersJob.perform_now
end

TabulateDailyRecordsJob.perform_now