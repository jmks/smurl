require 'sinatra'
require 'haml'

require './helpers'

require 'data_mapper'
require 'sqlite3'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{ Dir.pwd }/smurl.db")

class SmallUrl
  include DataMapper::Resource
  property :id,         Serial
  property :url,        String,  required: true
  property :accessed,   Integer
  property :created_at, DateTime

  def path
    "/#{ self.id }"
  end

  def full_url
    'http://' + self.url
  end
end

DataMapper.finalize

class Smurl < Sinatra::Base

  before do 
    @host = request.host_with_port
  end

  get '/urls' do
    @smurls = SmallUrl.all

    haml :urls
  end

  get '/:smurl?' do
    @encoded = params[:smurl]
    if @encoded
      id         = decode62(@encoded)
      @small_url = SmallUrl.first(id: id)
    end

    if @small_url
      @small_url.accessed += 1
      @small_url.save

      redirect @small_url.full_url and return
    end

    haml :index
  end

  post '/' do 
    @url       = params[:url]
    @small_url = get_small_url(@url)

    haml :index
  end

  helpers do
    include Helpers

    def get_small_url url
      url = clean_url url # uri?
      now = Time.now
      SmallUrl.first_or_create({ url: url }, { accessed: 0, created_at: now })
    end

    def clean_url url
      url.gsub /^https?:\/\//, ''
    end

    def small_url(smurl, host=@host)
      host + '/' + encode62(smurl.id)
    end
  end

end