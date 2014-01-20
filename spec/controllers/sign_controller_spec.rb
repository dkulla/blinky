require 'spec_helper'

describe SignController do

  before :each do
    LedString.stubs(:push!).returns true
  end

  describe '#index GET /sign(.:format)' do

    let(:a_sign){Sign.new(:phrase => 'What does the fox say')}
    before do
      controller.stubs(:sign).returns(a_sign)
    end

    it 'returns http success' do
      get :index
      response.should be_success
    end

    it 'should assign a phrase' do
      get :index
      assigns[:phrase].should == 'WHAT DOES THE FOX SAY'
    end

    it 'should assign sign' do
      get :index
      assigns[:sign].should == a_sign
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

  describe '#update PATCH /sign/:id(.:format)' do

    let(:sign){Sign.new}
    let(:params) do
      {
          id:1,
          sign:{
              effects:{
                  scrolling:  1,
                  solid_color:1
              },
              color:'#ff0000',
              background_color:'#008000'
          }
      }
    end
    before :each do
      controller.stubs(:sign).returns(sign)
    end

    it 'should redirect to sign_index' do
      put :update, params
      response.should redirect_to sign_index_path
    end

    it 'should set sign color' do
      put :update, params
      sign.color.should == Color::RGB::Red
      sign.background_color.should == Color::RGB::Green
    end

    context 'when save fails' do
      before { sign.stubs(:save).returns false}

      it 'should flash approprate flash mesage' do
        put :update, params
        flash[:error].should == 'Error saving sign.'
      end

      it 'should render index' do
        put :update, params
        response.should render_template(:index)
      end
    end

    it 'should attempt to update effects bitmask' do

    end

  end

end
