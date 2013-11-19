require 'spec_helper'

describe ApplicationHelper do

  describe '#flash_class' do
    it{helper.flash_class(:notice).should == 'alert-info'}
    it{helper.flash_class(:success).should == 'alert-success'}
    it{helper.flash_class(:error).should == 'alert-danger'}
    it{helper.flash_class(:alert).should == 'alert-warning'}
    it 'should raise an exception if level is unknown' do
      expect{helper.flash_class(:poop)}.to raise_error
    end

  end
end