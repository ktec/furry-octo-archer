require 'active_record'

module Db
  module_function

  def create
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
          table.column :followers, :integer
          table.column :stars, :integer
          table.column :following, :integer
          table.column :total_public_contributions_last_year, :integer
        end
      end
      unless ActiveRecord::Base.connection.tables.include? 'projects'
        create_table :projects do |table|
          table.column :user_id, :integer
          table.column :organization_id, :integer
          table.column :name, :string
        end
      end
    end
  end

  module Models
    class User < ActiveRecord::Base
      include ActiveModel::Serialization
      has_many :projects
    end

    class Project < ActiveRecord::Base
      belongs_to :user
      belongs_to :organisation
    end

    class Organiztion < ActiveRecord::Base
      include ActiveModel::Serialization
      has_many :projects
    end
  end
end
