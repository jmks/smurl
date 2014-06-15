require 'sinatra'
require 'haml'

class Smurl < Sinatra::Base

  get '/' do
    haml :index  
  end

end