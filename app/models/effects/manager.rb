module Effects
  module Manager extend self

    attr_reader :sign, :dead_thread
    attr_accessor :period

    # Runs effects in a loop in a seperate thread
    #
    def run(sign)
      @sign = sign
      self.stop
      clock = 0
      @threads << Thread.new do
        loop do
          run_iteration(clock)
          clock += 1
          sleep period
        end
      end
    end

    def thread
      @threads.last
    end

    def stop
      @threads ||= []
      @threads.each do |thr|
        Thread.kill(thr)
        @dead_thread = @threads.delete(thr)
      end
    end

    def period
      @period ||= 0.2
    end

    def run_iteration(clock)
      ActiveRecord::Base.connection_pool.with_connection do
        sign.effects.each do |effect|
          ('Effects::' + effect.to_s.camelize).constantize.run(sign, clock)
        end
      end
      LedString.push!
    end

  end
end