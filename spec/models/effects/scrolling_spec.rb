require 'spec_helper'
include Effects

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
      options = {sign: sign, clock:0, needs_update:false}
      Effects::Scrolling.run(options)
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
        Effects::Scrolling.run({sign:sign,clock:0})
      end

      it 'should need update at clock = 0' do
        options = {sign:sign, clock:0, needs_update:false}
        Effects::Scrolling.run(options)
        options[:needs_update].should == true
      end

      it 'should not scroll with full word' do
        sign.letter_number(0).expects(:set).with(:value => 'F')
        sign.letter_number(1).expects(:set).with(:value => 'A')
        sign.letter_number(2).expects(:set).with(:value => 'T')
        Effects::Scrolling.run({sign:sign,clock:10})
      end

      it 'should not need update afterwards' do
        options = {sign:sign, clock:10, needs_update:false}
        Effects::Scrolling.run(options)
        options[:needs_update].should == false
      end
    end

    context 'when word is longer than letters' do

      let(:sign){Sign.new(letter_order:[0,1,2], phrase:'POTATO', tempo:60)}

      it 'should need update at 0' do
        options = {sign:sign, clock:0, needs_update:false}
        Effects::Scrolling.run(options)
        options[:needs_update].should == true
      end

      it 'should not need update at 4' do
        options = {sign:sign, clock:4, time:1.2, needs_update:false}
        Effects::Scrolling.run(options)
        options[:needs_update].should == false
      end

      it 'should need update at 5' do
        options = {sign:sign, clock:5, time:1, needs_update:false}
        Effects::Scrolling.run(options)
        options[:needs_update].should == true
      end

      it 'should be blank on time 0' do
        sign.letter_number(0).expects(:set).with(:value => ' ')
        sign.letter_number(1).expects(:set).with(:value => ' ')
        sign.letter_number(2).expects(:set).with(:value => ' ')
        Effects::Scrolling.run({sign:sign,time:0})
      end

      it 'should show the first letter at time 1' do
        sign.letter_number(0).expects(:set_value).with(' ')
        sign.letter_number(1).expects(:set_value).with(' ')
        sign.letter_number(2).expects(:set_value).with('P')
        Effects::Scrolling.run({sign:sign,time:1})
      end

      it 'should show the first three letters at time 3' do
        sign.letter_number(0).expects(:set_value).with('P')
        sign.letter_number(1).expects(:set_value).with('O')
        sign.letter_number(2).expects(:set_value).with('T')
        Effects::Scrolling.run({sign:sign,time:3})
      end

      it 'should show the last letter at time 8' do
        sign.letter_number(0).expects(:set_value).with('O')
        sign.letter_number(1).expects(:set_value).with(' ')
        sign.letter_number(2).expects(:set_value).with(' ')
        Effects::Scrolling.run({sign:sign,time:8})
      end

      it 'should start the cycle over again last letter at time 10' do
        sign.letter_number(0).expects(:set_value).with(' ')
        sign.letter_number(1).expects(:set_value).with(' ')
        sign.letter_number(2).expects(:set_value).with('P')
        Effects::Scrolling.run({sign:sign,time:10})
      end
    end
  end

  describe '#step_number' do
    it 'should return the correct step number' do
      sign = Sign.new(:letter_order => [0], :phrase => 'TOY TRUCK', tempo:60)
      options = {sign:sign, clock:25, time:60, needs_update:false}
      Scrolling.run(options)
      Scrolling.step_number.should == 60
    end
  end

end
