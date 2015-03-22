require 'active_record'

ActiveRecord::Base.logger = Logger.new(File.open('./db/database.log', 'w'))

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => './db/example.db'
)

ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'users'
    create_table :users do |table|
      table.column :github_id, :integer
      table.column :fullname, :string
      table.column :username, :string
      table.column :email, :string
      table.column :worksfor, :string
      table.column :location, :string
      table.column :join_date, :datetime
      table.column :followers, :string
      table.column :stars, :string
      table.column :following, :string
      table.column :total_public_contributions_last_year, :string
    end
  end
  unless ActiveRecord::Base.connection.tables.include? 'projects'
    create_table :projects do |table|
        table.column :user_id, :integer
        table.column :name, :string
    end
  end
end

class User < ActiveRecord::Base
    has_many :projects
end

class Project < ActiveRecord::Base
    belongs_to :user
end
