require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the SignHelper. For example:
#
# describe SignHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe SignHelper do

  describe '#sign_background_color' do
    it 'should return background color in html' do
      sign = Sign.new(:background_color => Color::RGB::Green)
      helper.sign_background_color(sign).should == '#008000'
    end

    it 'should return blank if no background color' do
      sign = stub(:background_color => nil)
      helper.sign_background_color(sign).should == ''
    end
  end

  describe '#sign_color' do
    it 'should return background color in html' do
      sign = Sign.new(:color => Color::RGB::Green)
      helper.sign_color(sign).should == '#008000'
    end

    it 'should return blank if no background color' do
      sign = stub(:color => nil)
      helper.sign_color(sign).should == ''
    end
  end
end
