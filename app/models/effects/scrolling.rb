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
    end

    def run(sign, clock)
      self.reset
      @sign = sign
      clock = 0 if sign.phrase.size <= sign.letters.size
      sign.ordered_letters.each_with_index do |letter, idx|
        curr_idx = (idx+(clock/cycles).floor)%phrase.size
        letter.set_value(phrase[curr_idx])
      end
    end
  end
end