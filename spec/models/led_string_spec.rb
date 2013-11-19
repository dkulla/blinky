require 'spec_helper'

describe LedString do

  let(:s1){Segment.new(:length => 2)}
  let(:s2){Segment.new(:length => 3)}
  let(:string){LedString.new()}


  describe '#add_segments' do
    it 'should add segments' do
      string.add_segments([s1,s2])
      string.segments.count.should == 2
    end

    it 'should add segments' do
      string.add_segments(s1,s2)
      string.segments.count.should == 2
    end

    it 'should be able to add one segment' do
      string.add_segments(s2)
      string.segments.first.should == s2
    end
  end

  describe '#add_letter' do

    it 'should add segments in the correct order' do
      string.add_letters(Letter.new(segment_order:[2,5,4,1,3]))
      string.segments[0].number.should == 2
      string.segments[2].number.should == 4
      string.segments[4].number.should == 3
    end
  end

  describe '#color_at(index)' do
    it 'should return color of pixel at index' do
      string.add_segments(s1)
      s1.color = Color::RGB.new(3,2,1)
      string.color_at(0).should == Color::RGB.new(3,2,1)
    end
  end

  it 'should calculate length from segments' do
    string.segments << s1 << s2
    string.length.should == 5
  end


end