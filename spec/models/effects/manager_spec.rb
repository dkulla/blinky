require 'spec_helper'
include Effects

describe Effects::Manager do

  let(:sign){Sign.new(letter_order:[0,1], phrase:'HI')}

  before :each do
    LedString.new.add_sign(sign)
    LedString.stubs(:push!)
  end

  describe '#run_iteration' do

    let(:sign){Sign.new(:letter_order => [0,1,2], :phrase => 'WHORAY', :effects => [:scrolling])}

    before do
      Manager.stubs(:sign).returns(sign)
      Manager.stubs(:run_time).returns(42)
    end

    it 'should run scrolling effect' do
      options = {sign:sign, time:42, clock:0, needs_update: false}
      Scrolling.expects(:run).with(options)
      Manager.run_iteration(0)
    end

    it 'should LedString.push!' do
      LedString.expects(:push!)
      Manager.run_iteration(0)
    end

  end

  describe '#run_time' do
    it 'should return the time that the manager has been running' do
      Manager.stubs(:run_iteration)
      Manager.run(sign)
      now_time = Time.now
      Time.stubs(:now).returns(now_time + 20)
      Manager.run_time.should be_within(0.1).of(20)
    end
  end

  describe '#thread' do
    it 'should return the last thread' do
      Manager.stubs(:run_iteration)
      Manager.run(sign)
      thr1 = Manager.thread
      Manager.stop
      Manager.dead_thread.should == thr1
    end
  end

  describe '#run' do
    it 'should call run iteration' do
      Manager.expects(:run_iteration).with(0).returns true
      Manager.expects(:run_iteration).with(1).returns true
      Manager.period = 0.1
      Manager.run(sign)
      sleep 0.15
      Manager.stop
      Manager.dead_thread.join
    end
  end

  describe '#stop' do
    it 'should kill thread dead' do
      Manager.stubs(:run_iteration)
      Manager.run(sign)
      Manager.stop
      Manager.dead_thread.join
      Manager.dead_thread.alive?.should be_false
    end
  end
end
