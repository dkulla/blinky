module Form

  module Sign extend self

    def update(sign, params)
      sign.color =            Color::RGB.from_html(params[:color])
      sign.background_color = Color::RGB.from_html(params[:background_color])
      sign.effects = Hash(params[:effects]).keys.map(&:to_sym)
      sign.fade_time = params.fetch(:fade_time){nil}
      sign.tempo = params.fetch(:tempo){nil}
    end

  end

end