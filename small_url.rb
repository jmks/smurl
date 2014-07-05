require 'radix'
BASE = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a

require 'data_mapper'
require 'sqlite3'
require 'dm-sqlite-adapter'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{ Dir.pwd }/smurl.db")

class SmallUrl
  include DataMapper::Resource
  
  property :id,         Serial
  property :url,        String,  required: true
  property :accessed,   Integer
  property :created_at, DateTime

  def full_url
    'http://' + self.url
  end

  # returns url for a SmallUrl object, depends on current host
  def small_url(host=Smurl.host)
    custom_url = CustomUrl.first(smurl_id: id)
    link       = custom_url.link if custom_url
    path       = link || SmallUrl.encode62(id)

    relative = '/' + path
    if host
      host + relative
    else 
      relative
    end
  end

  # data access
  def self.get_small_url original_url, vanity=nil
    custom_url   = CustomUrl.first(link: vanity) if vanity
    
    original_url = SmallUrl.clean_url original_url
    now          = Time.now

    if custom_url
      SmallUrl.first(id: custom_url.smurl_id)
    elsif vanity and custom_url.nil?
      small_url  = SmallUrl.first_or_create({ url: original_url }, { accessed: 0, created_at: now })
      custom_url = CustomUrl.create(link: vanity, smurl_id: small_url.id)

      small_url
    else
      # TODO: if this is created, it needs a custom url!
      # TODO: it needs to check the custom url by its id doesn't already exist
      SmallUrl.first_or_create({ url: original_url }, { accessed: 0, created_at: now })
    end
  end

  def self.find_by_encoded_id encoded_id
    return nil unless encoded_id

    custom_url = CustomUrl.first(link: encoded_id)

    if custom_url
      SmallUrl.first(id: custom_url.smurl_id)
    else
      id = SmallUrl.decode62(encoded_id)
      SmallUrl.first(id: id)
    end
  end

  private

  # encodes integers into base 62 strings
  def self.encode62 integer
    integer.b(BASE.length).to_a.map { |i| BASE[i] }.join
  end

  # decodes base 62 strings into integers
  def self.decode62 string
    string.split('').map { |c| BASE.index(c) }.b(BASE.length).to_s(10).to_i
  end

  # removes protocol, for slightly better matching
  def self.clean_url url
    url.gsub /^https?:\/\//, ''
  end
end

class CustomUrl
  include DataMapper::Resource

  property :link,     String, key: true
  property :smurl_id, Integer
end

DataMapper.finalize