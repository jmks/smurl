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
  def small_url(host=@host)
    relative = '/' + SmallUrl.encode62(id)
    if host
      host + relative
    else 
      relative
    end
  end

  # data access
  def self.get_small_url url
    url = SmallUrl.clean_url url
    now = Time.now
    SmallUrl.first_or_create({ url: url }, { accessed: 0, created_at: now })
  end

  def self.find_by_encoded_id encoded_id
    if encoded_id
      id = SmallUrl.decode62(@encoded)
      SmallUrl.first(id: id)
    else
      nil
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

DataMapper.finalize