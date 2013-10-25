class BlinkerController < ApplicationController

  def start
    Blinker.start
    render nothing: true
  end

  def stop
    Blinker.stop
    render nothing: true
  end

end