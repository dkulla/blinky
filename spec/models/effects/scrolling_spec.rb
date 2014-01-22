require 'spec_helper'

describe Effects::Scrolling do

  describe '#phrase' do
    it 'should return phrase if sign has more letters than signs phrase' do
      sign = Sign.new(letter_order:[0,1,2], phrase:'FAT')
      Effects::Scrolling.reset
      Effects::Scrolling.stubs(:sign).returns(sign)
      Effects::Scrolling.phrase.should == 'FAT'
    end
  end

  describe '#cycles' do
    it 'should default to 5' do
      Effects::Scrolling.cycles.should == 5
    end
  end

  describe '#reset' do
    it 'should set phrase to nil' do
      sign = Sign.new(letter_order:[0,1,2], phrase:'FAT')
      Effects::Scrolling.run(sign, 0)
      Effects::Scrolling.reset
      Effects::Scrolling.instance_variable_get(:@phrase).should be_nil
    end
  end

  describe '#run' do

    before :each do
      LedString.new.add_sign(sign) if LedString.new?
    end

    context 'when word is shorter than letters' do
      let(:sign){Sign.new(letter_order:[0,1,2], phrase:'FAT')}

      it 'should start with full word' do
        sign.letter_number(0).expects(:set).with(:value => 'F')
        sign.letter_number(1).expects(:set).with(:value => 'A')
        sign.letter_number(2).expects(:set).with(:value => 'T')
        Effects::Scrolling.run(sign,0)
      end

      it 'should not scroll with full word' do
        sign.letter_number(0).expects(:set).with(:value => 'F')
        sign.letter_number(1).expects(:set).with(:value => 'A')
        sign.letter_number(2).expects(:set).with(:value => 'T')
        Effects::Scrolling.run(sign,10)
      end
    end

    context 'when word is longer than letters' do

      let(:sign){Sign.new(letter_order:[0,1,2], phrase:'POTATO')}

      it 'should be blank on clock 0' do
        sign.letter_number(0).expects(:set).with(:value => ' ')
        sign.letter_number(1).expects(:set).with(:value => ' ')
        sign.letter_number(2).expects(:set).with(:value => ' ')
        Effects::Scrolling.run(sign,0)
      end

      it 'should show the first letter at clock 1' do
        sign.letter_number(0).expects(:set_value).with(' ')
        sign.letter_number(1).expects(:set_value).with(' ')
        sign.letter_number(2).expects(:set_value).with('P')
        Effects::Scrolling.run(sign,5)
      end

      it 'should show the first three letters at clock 3' do
        sign.letter_number(0).expects(:set_value).with('P')
        sign.letter_number(1).expects(:set_value).with('O')
        sign.letter_number(2).expects(:set_value).with('T')
        Effects::Scrolling.run(sign,15)
      end

      it 'should show the last letter at clock 8' do
        sign.letter_number(0).expects(:set_value).with('O')
        sign.letter_number(1).expects(:set_value).with(' ')
        sign.letter_number(2).expects(:set_value).with(' ')
        Effects::Scrolling.run(sign,40)
      end

      it 'should start the cycle over again last letter at clock 10' do
        sign.letter_number(0).expects(:set_value).with(' ')
        sign.letter_number(1).expects(:set_value).with(' ')
        sign.letter_number(2).expects(:set_value).with('P')
        Effects::Scrolling.run(sign,50)
      end
    end
  end

end