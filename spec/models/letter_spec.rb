require 'spec_helper'

describe Letter do

  it 'should start with 16 segments' do
    l = Letter.new(:segments => [Segment.create(number:2)])
    l.segments.size.should == 16
  end

  describe '#segment_order' do

    it 'should not overwrite existing order' do
      l = Letter.new(segment_order:[1,2])
      l.segment_order.should == [1,2]
    end

    it 'should have default default order' do
      l = Letter.new
      l.segment_order.should == [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    end

    it 'should be able to store segment order' do
      l = Letter.new
      l.segment_order = [1,2,4,5]
      l.segment_order.should == [1,2,4,5]
    end
  end

  describe '#segement_number(number)' do

    it 'should return the correct number segment' do
      l = Letter.new(segment_order:[2,5,4,1,3])
      l.segment_number(1).number.should == 1
    end
  end

  describe '#ordered_segments' do

    context 'should return segments in order specified by segment_order' do
      let(:ordered){Letter.new(segment_order:[2,5,4,1,3]).ordered_segments}
      it{ordered[0].number.should == 2}
      it{ordered[2].number.should == 4}
      it{ordered[4].number.should == 3}
    end

  end

  describe '#set' do
    context 'should set letter to selected color' do
      before :each do
        @letter = Letter.new()
        LedString.new().add_letters(@letter)
        @letter.set(value: 'S', color: Color::RGB::Orange)
      end

      [0,1,2,7,8,13,14,15].each do |n|
        it{@letter.segments[n].color.should == Color::RGB::Orange}
      end

      ((0..15).to_a - [0,1,2,7,8,13,14,15]).each do |n|
        it{@letter.segments[n].color.should == Color::RGB::Black}
      end

    end
  end

end
