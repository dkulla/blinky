# == Schema Information
#
# Table name: signs
#
#  id           :integer          not null, primary key
#  phrase       :text
#  letter_order :text
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Sign do

  let(:sign){Sign.new}

  it 'should be able to have letters' do
    letter = Letter.new
    sign.letters << letter
    sign.letters.first.should == letter
  end

  it 'should have color attribute' do
    sign.color = Color::RGB::Red
    sign.color.should == Color::RGB::Red
  end

  describe '#add_letters' do
    let(:l1){Letter.new}
    let(:l2){Letter.new}

    before {sign.add_letters(l1,l2)}
    it {l1.number.should == 0}
    it {l2.number.should == 1}
    it {sign.letters.size.should == 2}

    it "should have the correct letter order" do
      sign.letter_order.should == [0,1]
    end
  end

  describe '#init' do
    context 'when adding letters directly' do
      let(:l1){Letter.new}
      let(:l2){Letter.new}
      before do
        @sign = Sign.new(letters:[l1,l2])
      end
      it{l1.number.should == 0}
      it{l2.number.should == 1}
      it{@sign.letter_order.should == [0,1]}
    end
  end

  describe '#letter_order' do

    it 'should not overwrite existing order' do
      s = Sign.new(letter_order:[1,2])
      s.letter_order.should == [1,2]
    end

    it 'should be able to store letter order' do
      l = Sign.new
      l.letter_order = [1,2,4,5]
      l.letter_order.should == [1,2,4,5]
    end
  end

  describe '#ordered_segments' do
    context 'should return segments in order specified by segment_order' do
      let(:ordered){Sign.new(letter_order:[2,5,4,1,3]).ordered_letters}
      it{ordered[0].number.should == 2}
      it{ordered[2].number.should == 4}
      it{ordered[4].number.should == 3}
    end
  end

  describe '#phrase' do
    it 'should store phrase' do
      sign.phrase = 'Hello there Guy'
      sign.phrase.should == 'HELLO THERE GUY'
    end
  end

  describe '#remove_letters' do
    %i(l1 l2 l3 l4).each do |ll|
      let(ll){Letter.new}
    end

    before do
      sign.add_letters(l1,l2,l3,l4)
      sign.set_letter_order(3,1,2,0)
      sign.remove_letters(l1,l3)
    end

    it{l2.number.should == 1}
    it{l4.number.should == 3}
    it{sign.letters.size.should == 2}

    it "should have the correct letter order" do
      sign.letter_order.should == [3,1]
    end

  end

  describe '#set_letter_order' do

    context 'when letters are added' do
      let(:sign) do
        s = Sign.new(letter_order:[1,4])
        s.set_letter_order(1,2,3,4)
        s
      end
      it 'should have the right number of letters' do
        sign.letters.size.should == 4
      end
      (1..4).to_a.each do |n|
        it{sign.letter_number(n).number.should == n}
      end
    end

    context 'when letters are subtracted' do
      let(:sign) do
        s = Sign.new(letter_order:[1,2,3,4])
        s.set_letter_order [1,4]
        s
      end
      it 'should have the right number of letters' do
        sign.letters.size.should == 2
      end
      [1,4].each do |n|
        it{sign.letter_number(n).number.should == n}
      end
      [2,3].each{|n| it{ expect(sign.letter_number(n)).to be_nil}}
    end
  end

  describe '#push' do
    it 'should save and push to LedString' do
      sign = Sign.new(phrase:'Hi Mom', letter_order:[0,1,2,3])
      LedString.new.add_sign(sign)
      Effects::Manager.expects(:run).with(sign)
      sign.expects(:save).returns true
      sign.push.should == true
    end
  end

end
