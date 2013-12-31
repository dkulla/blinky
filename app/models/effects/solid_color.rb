module Effects
  module SolidColor extend self
    def run(sign, clock)
      LedString.segments.each do |seg|
        seg.color= sign.color unless seg.color == Color::RGB::Black
      end
    end
  end
end
