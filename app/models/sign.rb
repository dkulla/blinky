# == Schema Information
#
# Table name: signs
#
#  id           :integer          not null, primary key
#  phrase       :text
#  letter_order :text
#  created_at   :datetime
#  updated_at   :datetime
#

class Sign < ActiveRecord::Base
  after_initialize :init
  has_many :letters, :dependent => :destroy

  serialize :letter_order, Array
  bitmask :effects, :as => [:scrolling]

  def init
    # Get letters without a set number
    new_letters = letters.select{|l| l.number.nil? }

    # Ensure letter has segment for each segment order
    (letter_order - letters.collect(&:number)).each do |n|
      letter = new_letters.pop
      if letter
        letter.number = n
      else
        letter = Letter.new(number:n)
        letters << letter
      end
      letter.save
    end

    #Add letters not added
    add_letters(new_letters, add:false)
  end

  def set_letter_order(*args)
    order = Array(args).flatten
    curr_letters = letters.collect(&:number)

    #Add Missing letters
    (order - curr_letters).each do |n|
      letters << Letter.new(number:n)
    end

    #Subtract extra letters
    (curr_letters - order).each do |n|
      l = letter_number(n)
      letters.delete(l)
      l.delete
    end

    self.letter_order= order
  end

  def phrase=(str)
    super str.upcase
  end

  # Adds letters to the sign
  #
  # @example
  # l1 = Letter.new
  # l2 = Letter.new
  # sign.add_letters(l1,l2)
  #
  def add_letters(*args, add: true)
    max = letter_order.max || -1
    Array(args).flatten.each do |l|
      l.number = (max += 1)
      letter_order << max
      letters << l if add
      l.save
    end
  end

  def remove_letters(*args)
    Array(args).each do |l|
      letters.delete(l)
      letter_order.delete(l.number)
      l.delete
    end
  end

  # Returns letter coresponding to the diagram above
  def letter_number(number)
    s = Array(letters.where(number:number)).first
    s || Array(letters.select{|ll| ll.number == number}).first
  end

  # Returns letters in order specifed by letter_order
  #
  def ordered_letters
    letter_order.collect{|n| letter_number(n)}
  end

  # Saves and pushes update to sign
  #
  def push
    ok = self.save
    LedString.new.add_sign(self) if ok && LedString.new?
    Effects::Manager.run(self) if ok
    ok
  end

  # Pushes updates to letters
  #
  def update_letters
    LedString.new.add_sign(self) if LedString.new?
    ordered_letters.each_with_index do |letter, idx|
      letter.set(:value => phrase[idx])
    end
  end

end
