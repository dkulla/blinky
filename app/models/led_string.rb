module LedString
  extend self

  attr_reader :segments

  def new
    @segments = []
    @string = nil
    self
  end

  def add_segments(*args)
    segments = Array(args).flatten
    segments.each{|s| s.led_string = self}
    @segments += segments
  end

  def add_letters(*args)
    letters = Array(args).flatten
    segs = letters.collect{|l| l.ordered_segments}
    add_segments(segs)
  end

  def add_sign(sign)
    add_letters(sign.ordered_letters)
  end

  def string
    @string ||= WS2801.new(:length => length)
  end

  def length
    @segments.collect(&:length).sum
  end

  def red!
    string.push_color Color::RGB.new(255, 0, 0)
  end

  def green!
    string.push_color Color::RGB.new(0, 255, 0)
  end

  def blue!
    string.push_color Color::RGB.new(0, 0, 255)
  end

  def push_color(color)
    string.push_color Color::RGB.from_html(color)
  end

  def to_a
    string.to_a
  end

  def set_color(color, range = :all)
    string.set_color(color, range)
  end

  def color_at(index)
    string.pixels[index]
  end

  def push!
    string.push!
  end

end
