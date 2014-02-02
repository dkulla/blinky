module Effects
  module HueFade extend self
    def run(options)
      clock = options[:clock]
      sign =  options[:sign]
      color = Color::HSL.new(clock%360,100,50)
      segs = sign.letters.collect(&:segments).flatten
      segs.each do |seg|
        seg.color = color if seg.on?
      end
      options[:needs_update] ||= true
    end
  end
end
