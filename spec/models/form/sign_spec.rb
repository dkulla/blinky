
require 'spec_helper'

describe Form::Sign do

  describe '#update' do

    it 'should assign values from params to sign' do

      params = {
        color: '#ff0000',
        background_color: '#008000',
        fade_time: '234',
        tempo: '128',
        effects:{
          scrolling:  1,
          solid_color:1
        }
      }

      sign = Sign.new

      Form::Sign.update(sign, params)

      sign.color.should ==            Color::RGB::Red
      sign.background_color.should == Color::RGB::Green
      sign.fade_time.should ==        234.0
      sign.tempo.should ==            128.0
      sign.effects.should ==          [:scrolling, :solid_color]
    end

  end


end