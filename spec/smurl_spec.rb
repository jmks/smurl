require 'rspec'

require_relative '../helpers'

describe 'Helpers' do
  include Helpers

  describe '#shrinkage' do 
    it 'returns the percentage shrunk' do 
      initial = 'abcdef'
      final   = '12'

      expect(shrinkage(initial, final)).to eql "33.33%"
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
        word.gsub(/^0+/, '')

        expect(encode62(decode62(word))).to eql word
      }
    end
  end
end