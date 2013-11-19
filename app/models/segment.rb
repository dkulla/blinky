class Segment < ActiveRecord::Base
  attr_accessor :led_string

  belongs_to :letter

  after_initialize :init

  def init
    self.length  ||= 2
  end

  def start
    idx = led_string.segments.index(self)
    (0..idx-1).collect{|i| led_string.segments[i].length }.sum
  end

  def range
    s = start
    (s..s+length-1)
  end

  def end
    range.end
  end

  def color
    led_string.color_at(start)
  end

  def color=(color)
    led_string.set_color color, range
  end

  def push!
    led_string.push!
  end
end