require 'rspec'
require 'pry'

require_relative './spec_helper'

# aliases for private methods
def encode62 arg
  SmallUrl.send(:encode62, arg)
end

def decode62 arg
  SmallUrl.send(:decode62, arg)
end

def clean_url url
  SmallUrl.send(:clean_url, url)
end

describe 'SmallUrl' do

  before :each do 
    # clean database
    CustomUrl.destroy
    SmallUrl.destroy

    # unsaved 
    @google = SmallUrl.new id: 1, url: 'https://www.google.ca', accessed: 0, created_at: Time.now
    
    # saved
    @slashdot        = SmallUrl.create url: 'www.slashdot.org', accessed: 0, created_at: Time.now
    @slashdot_custom = CustomUrl.create link: 'sd', smurl_id: @slashdot.id

    @cheez_url = 'http://www.cheezeburger.com'
  end

  describe 'self.get_small_url' do 

    context 'when using orginal_url only' do
      context 'when url is unknown' do
        it 'creates a new SmallUrl' do 
          expect {
            SmallUrl.get_small_url(@cheez_url)
          }.to change { SmallUrl.count }.by 1
        end

        it 'returns a SmallUrl' do 
          expect(SmallUrl.get_small_url(@cheez_url)).to be_an_instance_of SmallUrl
        end
      end

      context 'when url already exists' do
        it 'does not create a new SmallUrl' do 
          expect {
            SmallUrl.get_small_url(@slashdot.url)
          }.to change { SmallUrl.count }.by 0
        end

        it 'returns a SmallUrl' do 
          expect(SmallUrl.get_small_url(@slashdot.url)).to be_an_instance_of SmallUrl
        end
      end
    end

    context 'when using a vanity url' do 
      context 'if vanity is new' do 
        it 'creates a CustomUrl' do 
          cheez = SmallUrl.get_small_url(@cheez_url, 'cheez')

          expect(SmallUrl.find_by_encoded_id('cheez')).to eql cheez
        end
      end

      context 'if vanity already exists' do 
        it 'should not create a SmallUrl' do 
          expect {
            SmallUrl.get_small_url(@slashdot.url, @slashdot_custom.link)
          }.to change{ SmallUrl.count }.by 0
        end
      end
    end
  end

  describe '#small_url' do 
    it 'returns an url without protocol given a host name' do 
      expect(@google.small_url("localhost")).to eql 'localhost/1'
    end

    it 'returns a relative path with no host' do 
      expect(@google.small_url).to eql '/1'
    end
  end

  describe '#encode62' do
    it 'encodes 0 to 0' do 
      expect(encode62(0)).to eql '0'
    end

    it 'encodes 61 to Z' do
      expect(encode62(61)).to eql 'Z'
    end
  end

  describe '#decode62' do 
    it 'decodes "0" to 0' do 
      expect(decode62('0')).to eql 0
    end

    it 'decodes 10 into 62' do 
      expect(decode62('10')).to eql 62
    end
  end

  describe 'encode62 and decode62 are inverse functions' do 
    it 'decodes an encoded string' do 
      3.times {
        original = Random.new.rand(100...100000)

        expect(decode62(encode62(original))).to eql original
      }
    end

    it 'ignores leading-0s when decoding' do 
      word = '0BppC7R72c6'
      expect(encode62(decode62(word))).to eql word[1..-1]
    end

    it 'encodes a decoded string' do 
      3.times {
        length = Random.new.rand(1..10)
        word   = (0..length).map { |i| BASE.sample }.join
        # trim leading zeros
        word.gsub!(/^0+/, '')

        expect(encode62(decode62(word))).to eql word
      }
    end
  end

  describe '#clean_url' do 
    it 'removes leading http://' do 
      expect(clean_url('http://www.google.ca')).to eql 'www.google.ca'
    end

    it 'removes leading https://' do 
      expect(clean_url('https://www.google.ca')).to eql 'www.google.ca'
    end
  end

  describe 'after create hook' do 
    context 'when creating a new small url' do 
      context 'with no custom url' do 
        it 'creates a custom url based on its id' do 
          google     = SmallUrl.get_small_url @google.url
          encoded_id = SmallUrl.send(:encode62, google.id)

          expect(SmallUrl.find_by_encoded_id(encoded_id)).to eql google
        end
      end

      context 'with a custom url' do 
        it 'creates a custom url based on its id' do 
          google     = SmallUrl.get_small_url @google.url, 'elgoog'
          encoded_id = SmallUrl.send(:encode62, google.id)

          expect(SmallUrl.find_by_encoded_id(encoded_id)).to eql google
        end
      end
    end
  end
end