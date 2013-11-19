require 'spec_helper'

describe WS2801 do

  before :each do
    WS2801.any_instance.stubs(:to_piper)
  end

  it 'should have default length of 1' do
    WS2801.new().length.should == 1
  end

  it 'should be able to set length' do
    new = WS2801.new(:length => 2)
    new.length.should == 2
  end

  it 'should be able to set red value' do
    WS2801.new(:red => 20).pixels[0].red.should == 20
  end

  it 'should send red to platform driver' do
    WS2801.any_instance.expects(:to_piper).with([255, 0, 0, 255, 0, 0, 255, 0, 0])
    WS2801.new(:length => 3, :red => 255).push!
  end

  it 'should set all pixels to new color' do
    leds = WS2801.new(:length => 3)
    leds.set_color Color::RGB.new(0, 33, 200)
    leds.pixels[2].blue.should == 200
  end

  it 'should be able to push colors' do
    leds = WS2801.new(:length => 3, :red => 255)
    leds.push_color( Color::RGB.new(0, 255, 20 ) )
    leds.to_a.should == [0, 255, 20, 255, 0, 0, 255, 0, 0]
  end

end