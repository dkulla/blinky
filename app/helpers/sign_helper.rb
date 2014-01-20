module SignHelper

  def sign_background_color(sign)
    sign.background_color ? sign.background_color.html : ''
  end

  def sign_color(sign)
    sign.color ? sign.color.html : ''
  end
end
