require 'spec_helper'

describe ColorSerializer do

  describe '.dump' do
    it 'should convert color to rgb html string' do
      ColorSerializer.dump(Color::RGB::Green).should == '#008000'
    end
  end

  describe '.load' do
    it 'should convert html color to color' do
      ColorSerializer.load('#008000').should == Color::RGB::Green
    end
  end
end