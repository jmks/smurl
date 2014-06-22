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

  describe '#validate_smurl_params' do 
    it 'returns no errors for a valid url and vanity url' do 
      errors = validate_smurl_params url: 'goo.gl', vanity: 'g'

      expect(errors.length).to be 0
    end

    it 'returns errors for blank urls' do 
      errors = validate_smurl_params url: ''
      
      expect(errors.length).to eql 1
      expect(errors.first).to include 'empty'
    end

    it 'returns errors for blank urls' do 
      errors = validate_smurl_params url: '    '
      
      expect(errors.length).to eql 1
      expect(errors.first).to include 'empty'
    end

    it 'returns errors for illegal vanity urls' do 
      errors = validate_smurl_params url: 'validish.url', vanity: 'hash!'

      expect(errors.length).to eql 1
      expect(errors.first).to include 'only contain'
    end
  end
end