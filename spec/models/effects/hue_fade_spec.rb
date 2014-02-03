require 'spec_helper'

describe Effects::HueFade do

  def go_to_cycle(cycle)
    LedString.new.add_sign(sign)
    [10,cycle].each do |clk|
      @options = {sign: sign, clock:clk, needs_update:false}
      Effects::Scrolling.run(@options)
      Effects::HueFade.run(@options)
    end
  end

  describe '#run' do
    context 'with default settings' do
      let(:sign){Sign.new(letter_order:[0], phrase:'(')}

      before :each do
        go_to_cycle(180)
      end

      it 'should need update' do
        @options[:needs_update].should == true
      end

      it 'should set on segments the correct hue' do
        [5,12].each do |n|
          LedString.segments[n].color.should == Color::HSL.new(180,100,50)
        end
      end

      it 'should not change the background color' do
        ((0..15).to_a - [5,12]).each do |n|
          LedString.segments[n].color.should == nil
        end
      end
    end

    context 'with adjusted cycle time' do
      let(:sign){Sign.new(letter_order:[0], phrase:'(', fade_time:30)}

      before :each do
        go_to_cycle(75)
      end

      it 'should set on segments the correct hue' do
        [5,12].each do |n|
          LedString.segments[n].color.should == Color::HSL.new(180,100,50)
        end
      end

      it 'should not change the background color' do
        ((0..15).to_a - [5,12]).each do |n|
          LedString.segments[n].color.should == nil
        end
      end
    end
  end

end
