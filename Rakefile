require './small_url'

database_path = "#{ Dir.pwd }/smurl.db"
temp_db_path  = "#{ Dir.pwd }/smurl_temp.db"
test_db_path  = "#{ Dir.pwd }/smurl_test.db"

task :default => :test

namespace :db do

  desc 'migrates the db'
  task :migrate do
    if ENV['DATABASE_URL']
      puts "Using env #{ ENV['DATABASE_URL'] }"
    elsif File.exists? database_path
      puts "Using existing #{ database_path }"
    else
      migrate_database_tables
      puts "SmallUrl migrated"
    end
  end

  desc 'delete the db'
  task :drop do 
    rm database_path
  end
  
end

# hacky but it works
desc 'runs specs with clean database'
task :test do
  if File.exists? database_path
    mv database_path, temp_db_path
  end

  migrate_database_tables

  sh 'bundle exec rspec'

  rm database_path

  mv temp_db_path, database_path
end

desc 'run cucumber tests'
task :cuke do 
  # clean?
  sh 'bundle exec cucumber'
end

def migrate_database_tables
  SmallUrl.auto_migrate!
  CustomUrl.auto_migrate!
end