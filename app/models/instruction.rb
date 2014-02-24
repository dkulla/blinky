# == Schema Information
#
# Table name: instructions
#
#  id               :integer          not null, primary key
#  sequence_id      :integer
#  number           :integer
#  phrase           :text
#  effects          :integer
#  color            :string(255)
#  background_color :string(255)
#  fade_time        :float
#  tempo            :float
#  created_at       :datetime
#  updated_at       :datetime
#

class Instruction < ActiveRecord::Base
  after_initialize :init

  serialize :color, ColorSerializer
  serialize :background_color, ColorSerializer
  bitmask :effects, :as => [:scrolling, :solid_color, :hue_fade]

  def init
    # Set Defaults
    self.color ||= Color::RGB::White
    self.background_color ||= Color::RGB::Black
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

end
