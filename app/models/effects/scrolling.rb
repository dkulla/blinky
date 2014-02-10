module Effects
  module Scrolling
    extend self

    attr_reader :sign
    attr_accessor :cycles

    # Returns phrase to be used with currenc sign based on phrase size and
    #  number of letters in sign. This value is cached.
    #
    def phrase
      return @phrase if @phrase

      letters_size = sign.letters.size
      if sign.phrase.size > letters_size
        @phrase = ' '*letters_size + sign.phrase
      else
        @phrase = sign.phrase
      end
    end

    # Number of cycles before scrolling moves one letter
    #
    def cycles
      @cycles ||= 5
    end

    def reset
      @phrase = nil
      @step_number = nil
    end

    # Number scrolling steps that have been taken
    #
    def step_number
      @step_number ||= (@time.to_f/60.0*sign.tempo).floor
    end

    def run(options)
      self.reset
      @clock = options[:clock]
      @sign = options[:sign]
      @time = options.fetch(:time){0}
      @step_number = 0 if sign.phrase.size <= sign.letters.size
      sign.ordered_letters.each_with_index do |letter, idx|
        curr_idx = (idx+step_number)%phrase.size
        letter.set_value(phrase[curr_idx])
      end
      options[:needs_update] ||= needs_update
    end

  private
    # Returns true for false depending on if sing needs update
    #
    def needs_update
      return true if @clock == 0
      return true if sign.phrase.size > sign.letters.size && @time%(60/sign.tempo) < Manager.period - 0.001

      false
    end
  end
end
