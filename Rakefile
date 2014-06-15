require 'data_mapper'

database_path = "#{ Dir.pwd }/smurl.db"

task :default => :test

namespace :db do

  desc 'migrates the db'
  task :migrate do
    if ENV['DATABASE_URL']
      puts "Using env #{ ENV['DATABASE_URL'] }"
    elsif File.exists? database_path
      puts "Using existing #{ database_path }"
    else
      require './smurl'
      SmallUrl.auto_migrate!
      puts "SmallUrl migrated"
    end
  end

  desc 'delete the db'
  task :drop do 
    rm database_path
  end
  
end

desc 'runs all the the tests'
task :test do 
  sh 'bundle exec rspec'
end