module Effects
  module HueFade extend self
    def run(options)
      @clock = options[:clock]
      @sign  = options[:sign]
      @color = nil
      segs = @sign.letters.collect(&:segments).flatten
      segs.each do |seg|
        seg.color = color if seg.on?
      end
      options[:needs_update] ||= true
    end

  private

    def color
      return @color if @color
      period = Effects::Manager.period
      angle = 360/@sign.fade_time*period*@clock
      @color = Color::HSL.new(angle%360,100,50)
    end
  end
end
