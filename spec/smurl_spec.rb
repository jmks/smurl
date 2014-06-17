require 'rspec'

require_relative '../smurl'
require_relative '../helpers'

describe 'Helpers' do
  include Helpers

  describe '#shrinkage' do 
    it 'returns the percentage shrunk' do 
      initial = 'abcdef'
      final   = '12'

      expect(shrinkage(initial, final)).to eql '66.67%'
    end

    context 'when bad input' do 
      it 'returns unknown' do 
        expect(shrinkage('blah', 1)).to eql 'unknown'
      end
    end
  end
end