class SignController < ApplicationController

  # sign_index GET /sign(.:format)
  def index
    @sign = sign
    @phrase = sign.phrase
  end

  #phrase_sign_index PUT /sign/phrase(.:format)
  def phrase
    sign.phrase = phrase_params
    if sign.push
      flash[:success] = "The sign says #{sign.phrase}"
      redirect_to sign_index_path
    else
      flash[:error] = "Sorry, couldn't update sign"
      render :index
    end
  end

  def stop
    Effects::Manager.stop
    flash[:success] = 'Effects manager stopped'
    redirect_to sign_index_path
  end

  #sign PATCH /sign/:id(.:format)
  def update
    Form::Sign.update(sign, sign_params)
    if sign.save
      flash[:success] = 'Sign updated.'
      redirect_to sign_index_path
    else
      flash[:error] = 'Error saving sign.'
      render :index
    end
  end

private

  def phrase_params
    params.require(:phrase)
  end

  def sign_params
    params.require(:sign).permit(:color,
                                 :background_color,
                                 :fade_time,
                                 :tempo,
                                 {:effects => Sign.values_for_effects})
  end

end
