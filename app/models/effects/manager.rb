module Effects
  module Manager extend self

    attr_reader :thread, :sign
    attr_accessor :period

    # Runs effects in a loop in a seperate thread
    #
    def run(sign)
      @sign = sign
      self.stop
      clock = 0
      @thread = Thread.new do
        loop do
          run_iteration(clock)
          clock += 1
          sleep period
        end
      end
    end

    def stop
      Thread.kill(@thread) if @thread
    end

    def period
      @period ||= 1
    end

    def run_iteration(clock)
      sign.effects.each do |effect|
        ('Effects::' + effect.to_s.camelize).constantize.run(sign, clock)
      end
      LedString.push!
    end
  end
end