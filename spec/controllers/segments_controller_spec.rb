require 'spec_helper'

describe SegmentsController do

  describe '#update PUT /segments/:id(.:format)' do

    let(:new_params){{id:22, segment:{length: 11}}}

    before :each do
      @segment = Segment.new(length:10)
      @letter = stub(:id => 52)
      @segment.stubs(:letter).returns(@letter)
      Segment.stubs(:find).with('22').returns(@segment)
    end

    it 'should update segment length' do
      put :update, new_params
      @segment.length.should == 11
    end

    it 'should redirect to letter edit' do
      put :update, new_params
      should redirect_to edit_letter_path(@letter)
    end

    it "should let user know if can't update segment" do
      @segment.stubs(:update_attributes).returns false
      put :update, new_params
      flash[:error].should == 'Error updating segment.'
    end

  end

end
