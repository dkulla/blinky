# == Schema Information
#
# Table name: letters
#
#  id            :integer          not null, primary key
#  number        :integer
#  segment_order :text
#  sign_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_letters_on_sign_id  (sign_id)
#

require 'spec_helper'

describe Letter do

  it 'should start with 16 segments' do
    l = Letter.new(:segments => [Segment.create(number:2)])
    l.segments.size.should == 16
  end
  describe 'relations and properties' do
    it{ should belong_to :sign }
    it{ should have_many :segments }
    it{ should serialize(:segment_order).as Array}
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

  describe '#set_segment_order' do

    context 'when segments are added' do
      let(:letter) do
        l = Letter.new(segment_order:[1,4])
        l.set_segment_order(1,2,3,4)
        l
      end
      it 'should have the right number of segments' do
        letter.segments.size.should == 4
      end
      (1..4).to_a.each do |n|
        it{letter.segment_number(n).number.should == n}
      end
    end

    context 'when segments are subtracted' do
      let(:letter) do
        l = Letter.new(segment_order:[1,2,3,4])
        l.set_segment_order [1,4]
        l
      end
      it 'should have the right number of segments' do
        letter.segments.size.should == 2
      end
      [1,4].each do |n|
        it{letter.segment_number(n).number.should == n}
      end
      [2,3].each{|n| it{ expect(letter.segment_number(n)).to be_nil}}
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

  describe '#segment_lengths' do
    it 'should return an array of all the letters segment lengths' do
      l = Letter.new(segment_order:[0,1,2])
      l.ordered_segments.each_with_index{|s,i| s.length = i*2 }
      l.segment_lengths.should == [0,2,4]
    end
  end

  describe '#segment_lengths=' do
    let(:letter) do
      letter = Letter.new(segment_order:[0,1,2])
      letter.segment_lengths = [5,4,3]
      letter
    end
    it{letter.segment_number(0).length.should == 5}
    it{letter.segment_number(1).length.should == 4}
    it{letter.segment_number(2).length.should == 3}
  end

  describe '#set' do
    context 'should set letter segments correctly' do
      before :each do
        @letter = Letter.new
        LedString.new.add_letters(@letter)
        @letter.set(value: 'S')
      end

      it 'should recive color for correct segments' do
        [0,1,2,7,8,13,14,15].each do |n|
          @letter.segments[n].on?.should be_true
        end
      end

      it 'should recieve no color for correct segments ' do
        ((0..15).to_a - [0,1,2,7,8,13,14,15]).each do |n|
          @letter.segments[n].off?.should be_true
        end
      end

    end
  end

  describe '#set_value' do
    it 'should recive set with value' do
      letter = Letter.new
      letter.expects(:set).with(value:'B')
      letter.set_value('B')
    end
  end
end
