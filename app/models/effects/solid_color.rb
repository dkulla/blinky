module Effects
  module SolidColor extend self
    def run(sign, clock)
      LedString.segments.each do |seg|
        seg.color= (seg.on? ? sign.color : sign.background_color)
      end
    end
  end
end
