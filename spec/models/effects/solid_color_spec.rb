require 'spec_helper'

describe Effects::SolidColor do

  def run_setup
    LedString.new.add_sign(sign)
    [1,11].each do |clk|
      Effects::Scrolling.run(sign,clk)
      Effects::SolidColor.run(sign,clk)
    end
  end

  describe '#run' do

    context 'with default sign' do
      let(:sign){Sign.new(letter_order:[0], phrase:'81')}

      before :each do
        run_setup
      end

      it 'should set segments the signs color' do
        [5,6,13].each do |n|
          LedString.segments[n].color.should == Color::RGB::White
        end
      end

      it 'should not change background color' do
        ((0..15).to_a - [5,6,13]).each do |n|
          LedString.segments[n].color.should == Color::RGB::Black
        end
      end
    end

    context 'with custom solid colors' do
      let(:sign){Sign.new(letter_order:[0], phrase:'81',
                          color: Color::RGB::GreenYellow,
                          background_color: Color::RGB::BlueViolet
      )}

      before :each do
        run_setup
      end

      it 'should set segments the signs color' do
        [5,6,13].each do |n|
          LedString.segments[n].color.should == Color::RGB::GreenYellow
        end
      end

      it 'should not change background color' do
        ((0..15).to_a - [5,6,13]).each do |n|
          LedString.segments[n].color.should == Color::RGB::BlueViolet
        end
      end
    end
  end

end