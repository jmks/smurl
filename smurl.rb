require 'sinatra'
require 'haml'

require './helpers'

# the model
require './small_url'

class Smurl < Sinatra::Base

  before do 
    @host ||= ENV['HOST'] || request.host_with_port
  end

  get '/urls' do
    @smurls = SmallUrl.all

    haml :urls
  end

  get '/:smurl?' do
    @encoded = params[:smurl]
    @small_url = SmallUrl.find_by_encoded_id(@encoded)

    if @small_url
      @small_url.accessed += 1
      @small_url.save

      redirect @small_url.full_url and return
    end

    haml :index
  end

  post '/' do 
    @url    = params[:url]
    @vanity = params[:vanity]

    @errors = validate_smurl_params params

    
    if SmallUrl.find_by_encoded_id(@vanity)
      @errors << "Custom name '#{@vanity}' already exists"
    end

    @small_url = SmallUrl.get_small_url(@url, @vanity) unless @errors.any?

    haml :index
  end

  def self.host
    @host
  end

  helpers Helpers

end