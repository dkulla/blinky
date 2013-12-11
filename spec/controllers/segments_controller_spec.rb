require 'spec_helper'

describe SegmentsController do

  describe '#update PUT /segments/:id(.:format)' do

    let(:new_params){{id:22, segment:{length: 11}}}

    before :each do
      @segment = Segment.new(length:10)
      Segment.stubs(:find).with('22').returns(@segment)
    end

    it 'should update segment length' do
      put :update, new_params
      @segment.length.should == 11
    end

  end

end
