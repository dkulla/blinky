class Color::RGB

  def to_a
    [red.to_i, green.to_i, blue.to_i]
  end
end

# Represents a GPIO pin on the Raspberry Pi
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
    @pixels = Array.new(@length, Color::RGB.new(0,0,0)) # Array of colors

    range.each do |idx|
      p = @pixels[idx]
      p.red = @options[:red]
      p.green = @options[:green]
      p.blue = @options[:blue]
    end

    push!
    self
  end

  def red=(value, opts = {:range => :all})
    if opts[:range] == :all
      @pixels.each do |p|
        p.red = value
      end
    end
    push!
  end

  def green=(value, opts = {:range => :all})
    if opts[:range] == :all
      @pixels.each do |p|
        p.green = value
      end
    end
    push!
  end

  def blue=(value, opts = {:range => :all})
    if opts[:range] == :all
      @pixels.each do |p|
        p.blue = value
      end
    end
    push!
  end

  def color=(color, range = :all)
    range = (range = :all ? (0..@length - 1) : range)
    range.each do |idx|
      p = @pixels[idx]
      p.red = color.red
      p.green = color.green
      p.blue = color.blue
    end
    push!
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
    #Platform.driver.ada_spi_out(@pixels.collect(&:to_a).flatten)
    array = self.to_a
    to_piper(array)
  end

  def to_piper(array)
    PiPiper::Spi.begin do
      write array
    end
  end

end