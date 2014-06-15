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

  end

  describe '#decode62' do 

  end
end