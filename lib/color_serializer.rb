class ColorSerializer < Array
  def self.dump(color)
    color ? color.html : nil
  end

  def self.load(color)
    color ? Color::RGB.from_html(color) : nil
  end
end