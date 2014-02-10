# == Schema Information
#
# Table name: letters
#
#  id            :integer          not null, primary key
#  number        :integer
#  segment_order :text
#  sign_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_letters_on_sign_id  (sign_id)
#

# Represents a sixteen segment single letter, it looks like this
#
#  --- 0 --- --- 1 ---
# |\        |        /|
# | \       |       / |
# |  \      |      /  |
# |   \     |     /   |
# 2    3    4    5    6
# |     \   |   /     |
# |      \  |  /      |
# |       \ | /       |
# |        \|/        |
#  --- 7 --- --- 8 ---
# |        /|\        |
# |       / | \       |
# |      /  |  \      |
# |     /   |   \     |
# 9   10   11   12   13
# |   /     |     \   |
# |  /      |      \  |
# | /       |       \ |
# |/        |        \|
#  -- 14 --- -- 15 ---

class Letter < ActiveRecord::Base
  after_initialize :init

  belongs_to :sign
  has_many :segments, :dependent => :destroy, :autosave => true

  serialize :segment_order, Array

  CONVERSION = {
    :'0' => [0,1,2,5,6,9,12,13,14,15],
    :'1' => [5,6,13],
    :'2' => [0,1,6,7,8,9,14,15],
    :'3' => [0,1,6,8,13,14,15],
    :'4' => [2,6,7,8,13],
    :'5' => [0,1,2,7,8,13,14,15],
    :'6' => [0,2,7,8,9,13,14,15],
    :'7' => [0,1,6,13],
    :'8' => [0,1,2,6,7,8,9,13,14,15],
    :'9' => [0,1,2,6,7,8,13,15],

    :''  => [],
    :' ' => [],
    :'=' => [7,8,14,15],
    :+ => [4,7,8,11],
    :- => [7,8],
    :* => [3,4,5,7,8,10,11,12],
    :"'" => [5],
    :'?' => [0,1,5,8,11],
    :'(' => [5,12],
    :')' => [3,10],
    :'[' => [1,4,11,15],
    :']' => [0,4,11,14],
    :'|' => [4,11],
    :'.' => [11],
    :/ => [5,10],
    :'\\' => [3,12],
    :'$' => [0,1,2,4,7,8,11,13,14,15],

    :A => [0,1,2,6,7,8,9,13],
    :B => [0,1,2,5,7,8,9,13,14,15],
    :C => [0,1,2,9,14,15],
    :D => [0,1,4,6,11,13,14,15],
    :E => [0,1,2,7,9,14,15],
    :F => [0,1,2,7,9],
    :G => [0,1,2,8,9,13,14,15],
    :H => [2,6,7,8,9,13],
    :I => [0,1,4,11,14,15],
    :J => [6,9,13,14,15],
    :K => [2,5,7,9,12],
    :L => [2,9,14,15],
    :M => [2,3,5,6,9,13],
    :N => [2,3,3,6,9,12,13],
    :O => [0,1,2,6,9,13,14,15],
    :P => [0,1,2,6,7,8,9],
    :Q => [0,1,2,6,9,12,13,14,15],
    :R => [0,1,2,6,7,8,9,12],
    :S => [0,1,2,7,8,13,14,15],
    :T => [0,1,4,11],
    :U => [2,6,9,13,14,15],
    :V => [2,5,9,10],
    :W => [2,6,9,10,12,13],
    :X => [3,5,10,12],
    :Y => [2,6,7,8,11],
    :Z => [0,1,5,10,14,15]
  }

  def init
    self.segment_order = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15] if segment_order.empty?

    # Ensure letter has segment for each segment order
    (segment_order - segments.collect(&:number)).each do |n|
      segments << Segment.new(number: n)
    end

  end

  def set_segment_order(*args)
    order = Array(args).flatten
    curr_segments = segments.collect(&:number)

    #Add Missing Segments
    (order - curr_segments).each do |n|
      segments << Segment.new(number:n)
    end

    #Subtract extra segments
    (curr_segments - order).each do |n|
      s = segment_number(n)
      segments.delete(s)
      s.delete
    end

    self.segment_order= order
  end

  def set(opts = {})
    value = opts[:value]
    value_segments = CONVERSION.fetch(value.to_s.to_sym){[]}
    segments.each do |s|
      s.on = value_segments.include?(s.number)
    end
  end

  def set_value(value)
    self.set(value:value)
  end

  # Returns segment corresponding to the diagram above
  def segment_number(number)
    s = Array(segments.select{|ss| ss.number == number}).first
    s || Array(segments.where(number:number)).first
  end

  def ordered_segments
    segment_order.collect{|n| segment_number(n)}
  end

  # Returns array of segment lengths
  def segment_lengths
    ordered_segments.collect{|s| s.length}
  end

  def segment_lengths=(*args)
    lengths = Array(args[0]).flatten
    segs = ordered_segments
    seg_size = segs.size
    lengths.each_with_index do |len, idx|
      return if idx > seg_size
      segs[idx].length = len
    end
    segs.map(&:save)
  end
end
