require 'spec_helper'

describe Effects::SolidColor do

  describe '#run' do

    let(:sign){Sign.new(letter_order:[0], phrase:'1', color:Color::RGB::Red)}

    before :each do
      LedString.new.add_sign(sign)
      Effects::Scrolling.run(sign,0)
      Effects::SolidColor.run(sign,0)
    end

    it 'should set segments the signs color' do
      [5,6,13].each do |n|
        LedString.segments[n].color.should == Color::RGB::Red
      end
    end

    it 'should not change background color' do
      ((0..15).to_a - [5,6,13]).each do |n|
        LedString.segments[n].color.should == Color::RGB::Black
      end
    end
  end

end