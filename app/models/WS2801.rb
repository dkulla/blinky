class Color::RGB
  def to_a
    [red.to_i, green.to_i, blue.to_i]
  end
end

class Color::HSL
  def to_a
    rgb = self.to_rgb
    [rgb.red.to_i, rgb.green.to_i, rgb.blue.to_i]
  end
end

# String of WS2801
class WS2801

  attr_accessor :pixels
  attr_reader :length
  alias_method :size, :length

  def initialize(opts = {})
    @options = {
        length: 1,
        red: 0,
        green: 0,
        blue: 0,
        range: :all,
        logger: Logger.new(STDOUT)
    }.merge(opts)
    @length = @options[:length]
    @logger = @options[:logger]
    range = (@options[:range] == :all ? (0..@length-1) : @options[:range])

    # Set Initial State
    @pixels = Array.new(@length, Color::RGB.new(0,0,0)) # Array of colors

    range.each do |idx|
      p = @pixels[idx]
      p.red = @options[:red]
      p.green = @options[:green]
      p.blue = @options[:blue]
    end

    self
  end

  def set_color(color, range = :all)
    range = (range == :all ? (0..@length - 1) : range)
    range.each do |idx|
      @pixels[idx] = color
    end
  end

  def push_color(color)
    @pixels.insert(0,color)
    @pixels.slice!(@length..-1)
    push!
  end

  # Set pixel to color
  #
  # Example:
  #  >> WS2801.set { :r => 255, :pixel => [1..10] }
  #  >> WS2801.set { :g => 128, :pixel => :all }
  #  >> WS2801.set { :r => 40, :g => 255, :b => 200, :pixel => 4 }
  #
  # Options:
  #  :pixel => []      # array with pixel ids
  #         :r => (Integer)
  #         :g => (Integer)
  #         :b => (Integer)
  def set(opts = {})

  end

  def to_a
    @pixels.collect(&:to_a).flatten
  end

  def push!
    array = self.to_a
    to_piper(array)
  end

  def to_piper(array)
    #PiPiper::Spi.begin do
    #  write array
    #end
    PiPiper::Spi.spidev_out(array)
  end

end