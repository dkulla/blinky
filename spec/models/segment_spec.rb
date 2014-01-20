# == Schema Information
#
# Table name: segments
#
#  id        :integer          not null, primary key
#  length    :integer
#  number    :integer
#  letter_id :integer
#
# Indexes
#
#  index_segments_on_letter_id  (letter_id)
#

require 'spec_helper'

describe Segment do

  let(:s1){Segment.new(length: 2)}
  let(:s2){Segment.new(length: 3)}
  let(:leds){LedString.new()}

  describe 'relations' do
    it{ should belong_to :letter}
    it{ should respond_to :led_string}
    it{ should respond_to :on?}
    it{ should respond_to :off?}
  end

  describe '#on/off' do
    it 'should be not be on after init' do
      expect(s1.on?).to be_false
    end

    it 'should be off after init' do
      expect(s1.off?).to be_true
    end

    it 'should should turn on and off' do
      s1.on = true
      s1.off!.off?.should be_true
      s1.on!.on?.should be_true
    end
  end

  describe '#color=' do

    before :each do
      leds.add_segments(s1, s2)
    end

    it 'should be able to set the segment color' do
      s1.color = Color::RGB.new(1,2,3)
      s2.color = Color::RGB.new(33,33,11)
      leds.to_a.should == [1, 2, 3, 1, 2, 3, 33, 33, 11, 33, 33, 11, 33, 33, 11]
    end

  end

  describe '#color' do
    it 'should return segment color' do
      leds.add_segments(s1,s1)
      s1.color = Color::RGB.new(3,3,3)
      s1.color.should == Color::RGB.new(3,3,3)
    end
  end

  describe '#length' do

    it "should know it's length" do
      Segment.new(:length => 5).length.should == 5
    end

    it 'should have default length 1' do
      Segment.new.length.should == 1
    end
  end

  describe '#led_string' do

    it 'should be set when added added to a LedString' do
      leds.add_segments(s1)
      s1.led_string.should == leds
    end
  end

  describe '#range' do
    it 'should know its range in the string' do
      leds.add_segments(s1,s2)
      s1.range.should == (0..1)
      s2.range.should == (2..4)
    end
  end

  describe '#start' do
    it "should known it's start led number" do
      leds.add_segments(s1,s2)
      s1.start.should == 0
      s2.start.should == 2
    end
  end

  describe '#end' do
    it "should known it's end led number" do
      leds.add_segments(s1,s2)
      s1.end.should == 1
      s2.end.should == 4
    end
  end

end
