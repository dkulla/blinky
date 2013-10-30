class BlinkerController < ApplicationController

  def start
    Blinker.start
    render nothing: true
  end

  def stop
    Blinker.stop
    render nothing: true
  end

  def red
    LedString.red!
    render nothing: true
  end

  def green
    LedString.green!
    render nothing: true
  end

  def blue
    LedString.blue!
    render nothing: true
  end

  # color_blinker_index PUT /blinker/color(.:format) blinker#color
  def color
    LedString.push_color(params[:color])
    render nothing: true
  end



end