module Effects
  module Scrolling
    extend self

    attr_reader :sign

    def phrase
      letters_size = sign.letters.size
      if sign.phrase.size > letters_size
        ' '*letters_size + sign.phrase
      else
        sign.phrase
      end
    end

    def run(sign, clock)
      @sign = sign
      phrs = phrase
      clock = 0 if sign.phrase.size <= sign.letters.size
      sign.ordered_letters.each_with_index do |letter, idx|
        curr_idx = (idx+clock)%phrs.size
        letter.set_value(phrs[curr_idx])
      end
    end
  end
end