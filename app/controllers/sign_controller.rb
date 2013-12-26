class SignController < ApplicationController

  # sign_index GET /sign(.:format)
  def index
    @phrase = sign.phrase
  end

  #phrase_sign_index PUT /sign/phrase(.:format)
  def phrase
    sign.phrase = phrase_params
    if sign.update
      flash[:success] = "The sign says #{sign.phrase}"
      redirect_to sign_index_path
    else
      flash[:error] = "Sorry, couldn't update sign"
      render :index
    end
  end

private

  def phrase_params
    params.require(:phrase)
  end

end
