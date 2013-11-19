require 'spec_helper'

describe Sign do

  let(:sign){Sign.new}

  it 'should be able to have letters' do
    letter = Letter.new
    sign.letters << letter
    sign.letters.first.should == letter
  end

  describe '#phrase' do
    it 'should store phrase' do
      sign.phrase = 'Hello there Guy'
      sign.phrase.should == 'HELLO THERE GUY'
    end
  end

  describe '#set_phrase' do

  end

end
