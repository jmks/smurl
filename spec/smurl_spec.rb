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

  describe '#format_date' do 
    it 'formats the date for human eyes' do 
      date     = DateTime.new(2014, 6, 9, 18, 07)
      expected = 'Jun 9, 2014 @ 6:07pm'

      expect(format_date(date)).to eql expected
    end
  end
end