require 'spec_helper'

describe Effects::Manager do

  let(:sign){Sign.new(letter_order:[0,1], phrase:'HI')}

  before :each do
    LedString.new.add_sign(sign)
    LedString.stubs(:push!)
  end

  describe '#run_iteration' do

    let(:sign){Sign.new(:letter_order => [0,1,2], :phrase => 'WHORAY', :effects => [:scrolling])}

    before do
      Effects::Manager.stubs(:sign).returns(sign)
    end

    it 'should run scrolling effect' do
      Effects::Scrolling.expects(:run).with(sign,0)
      Effects::Manager.run_iteration(0)
    end

    it 'should LedString.push!' do
      LedString.expects(:push!)
      Effects::Manager.run_iteration(0)
    end

  end

  describe '#run' do
    it 'should call run iteration' do
      Effects::Manager.expects(:run_iteration).with(0).returns true
      Effects::Manager.expects(:run_iteration).with(1).returns true
      Effects::Manager.period = 0.1
      Effects::Manager.run(sign)
      sleep 0.15
      Effects::Manager.stop
      Effects::Manager.thread.join
    end
  end

  describe '#stop' do
    it 'should kill thread dead' do
      Effects::Manager.stubs(:run_iteration)
      Effects::Manager.run(sign)
      Effects::Manager.stop
      Effects::Manager.thread.join
      Effects::Manager.thread.alive?.should be_false
    end
  end
end