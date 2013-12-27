require 'spec_helper'

describe SignController do

  before :each do
    LedString.stubs(:push!).returns true
  end

  describe '#index GET /sign(.:format)' do
    it 'returns http success' do
      get :index
      response.should be_success
    end

    it 'should assign a phrase' do
      a_sign = Sign.new(:phrase => 'What does the fox say')
      controller.stubs(:sign).returns(a_sign)
      get :index
      assigns[:phrase].should == 'WHAT DOES THE FOX SAY'
    end
  end

  describe '#phrase PUT /sign/phrase(.:format)' do
    context 'with updateable sign' do
      before :each do
        @lyric = "We've come too far, To give up who we are."
        mock_sign = mock(:push => true, :phrase => @lyric.upcase)
        mock_sign.expects(:phrase=).with(@lyric)
        controller.stubs(:sign).returns(mock_sign)
      end
      it 'expects to set sign phrase' do
        put :phrase, {phrase: @lyric}
        flash[:success].should == "The sign says WE'VE COME TOO FAR, TO GIVE UP WHO WE ARE."
      end

      it 'should redirect to sign index' do
        put :phrase, {phrase: @lyric}
        response.should redirect_to sign_index_path
      end
    end

    it 'should flash alert if cant save' do
      lyric = 'I came in like a wrecking ball'
      mock_sign = mock(:push => false)
      mock_sign.expects(:phrase=).with(lyric)
      controller.stubs(:sign).returns(mock_sign)
      put :phrase, {phrase:lyric}
      flash[:error].should == "Sorry, couldn't update sign"
    end

  end

  describe '#stop PUT /sign/stop(.:format)' do
    it 'should tell effects manager to stop' do
      Effects::Manager.expects(:stop)
      put :stop
      flash[:success].should == 'Effects manager stopped'
    end
  end

end
