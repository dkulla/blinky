# == Schema Information
#
# Table name: signs
#
#  id               :integer          not null, primary key
#  phrase           :text
#  letter_order     :text
#  created_at       :datetime
#  updated_at       :datetime
#  effects          :integer
#  color            :string(255)
#  background_color :string(255)
#  fade_time        :float
#  tempo            :float
#
# Indexes
#
#  index_signs_on_effects  (effects)
#

class Sign < ActiveRecord::Base
  after_initialize :init
  has_many :letters, :dependent => :destroy, :autosave => true

  serialize :letter_order, Array
  serialize :color, ColorSerializer
  serialize :background_color, ColorSerializer
  bitmask :effects, :as => [:scrolling, :solid_color, :hue_fade]

  def init
    # Set Defaults
    self.color ||= Color::RGB::White
    self.background_color ||= Color::RGB::Black

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

  # Fade Cycle Time for sign effects that invlove fadeing from one color to another
  #
  def fade_time
    super || 72
  end

  # Tempo of the display in beats/minute default is 60
  def tempo
    super || 60
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
    s = Array(letters.select{|ll| ll.number == number}).first
    s || Array(letters.where(number:number)).first
  end

  # Returns letters in order specified by letter_order
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

end
