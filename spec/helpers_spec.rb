require 'rspec'
require_relative './spec_helper'

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

    it 'returns errors for empty urls' do 
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

    context 'when blacklisted custom urls' do 
      before :each do 
        @params = { url: 'anothervalid.url', vanity: 'yolo' }
        @blacklisted = ['urls', 'yolo']
      end

      it 'returns errors for blacklisted urls' do 
        errors = validate_smurl_params(@params, @blacklisted)

        expect(errors).to_not be_empty
        expect(errors.first).to include 'cannot be used'
      end
    end
  end

  describe '#blacklisted_urls' do 
    before :each do 
      @filename ='blacklist_test.txt'

      # create the blacklist_test.txt file
      File.delete(@filename) if File.exists?(@filename)
      File.open(@filename, 'w') do |f|
        f << 'yolo'
      end
    end

    after :each do 
      File.delete(@filename)
    end
    
    it 'contains program used urls in blacklist' do 
      settings = mock()
      # called in test and in execution
      settings.should_receive(:unusable_custom_urls).twice.and_return(['urls'])
      settings.should_receive(:smurl_blacklist).and_return(nil)

      settings.unusable_custom_urls.each do |bad|
        expect(blacklisted_urls(settings)).to include bad
      end
    end

    it 'returns a list from a file in an env variable' do 
      settings = mock()
      settings.should_receive(:unusable_custom_urls).and_return(['urls'])
      # called on nil check and to get contents
      settings.should_receive(:smurl_blacklist).twice.and_return(@filename)

      expect(blacklisted_urls(settings)).to include 'yolo'
    end
  end
end