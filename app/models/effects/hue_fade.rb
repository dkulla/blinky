module Effects
  module HueFade extend self
    def run(sign, clock)
      color = Color::HSL.new(clock%360,100,50)
      segs = sign.letters.collect(&:segments).flatten
      segs.each do |seg|
        seg.color = color if seg.on?
      end
    end
  end
end
