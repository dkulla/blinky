class Sign < ActiveRecord::Base
  has_many :letters

  def phrase=(str)
    super str.upcase
  end
end
