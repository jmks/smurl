require 'sinatra'
require 'haml'

require './helpers'

require 'radix'
BASE = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a

class Smurl < Sinatra::Base

  get '/' do
    haml :index  
  end

  post '/' do 
    @url           = params[:url]
    @shortened_url = get_or_set_short_url(@url)

    haml :index
  end

  helpers do
    include Helpers

    def get_or_set_short_url url
      "smurl"
    end
  end

end