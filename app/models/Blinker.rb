module Blinker
  extend self

  @blinking = false

  def start
    @blinking = true
    Thread.new do
      loop do
        break unless @blinking
        pin.on
        sleep 1
        pin.off
        sleep 1
      end
    end
  end

  def pin
    @pin ||= PiPiper::Pin.new(:pin => 17, :direction => :out)
  end

  def stop
    @blinking = false
  end
end