# db/migrate/YYYYMMDDHHMMSS_create_users.rb
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :uuid, limit: 36
      t.string :gender, limit: 6, inclusion: { in: %w[male female] }
      t.jsonb :name
      t.jsonb :location
      t.integer :age

      t.timestamps
    end
  end
end
