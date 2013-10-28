module Blinker
  extend self

  @blinking = false

  def start
    @blinking = true
    Rails.logger.info("Blinking = #{@blinking}")
    pin.on
    #Thread.new do
    #  loop do
    #    break unless @blinking
    #    pin.on
    #    sleep 1
    #    pin.off
    #    sleep 1
    #    Rails.logger.info("Blink!")
    #  end
    #end
  end

  def pin
    @pin ||= PiPiper::Pin.new(:pin => 17, :direction => :out)
  end

  def stop
    pin.off
    @blinking = false
    Rails.logger.info("Blinking = #{@blinking}")
  end
end