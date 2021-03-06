# Generated by cucumber-sinatra. (2014-06-16 22:11:16 -0400)

ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', '..', 'smurl.rb')

require 'capybara'
require 'capybara/cucumber'
require 'rspec'
require 'pry'

Capybara.app = Smurl

class SmurlWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  SmurlWorld.new
end