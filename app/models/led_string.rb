module LedString
  extend self

  def string
    @string ||= WS2801.new(:length => 3, :red => 200, :green => 100)
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



end
