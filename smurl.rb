require 'sinatra'
require 'haml'

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
    def get_or_set_short_url url
      "smurl"
    end

    def shrinkage(original, short)
      percent = 100.0 * short.length / original.length
      "#{percent}%"
    end
  end

end