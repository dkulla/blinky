class LettersController < ApplicationController

  #GET /letters(.:format)
  def index
    @letters = sign.ordered_letters
    @new_letter = Letter.new
  end

  #POST /letters(.:format)
  def create
    letter = Letter.new(segment_order: JSON.parse(letter_params[:segment_order]))
    if sign.add_letters(letter) && sign.save
      flash[:success] = 'Letter created successfully'
      redirect_to letters_path
    else
      flash[:error] = 'Letter could not be created'
      render :index
    end
  end

  #edit_letter GET /letters/:id/edit(.:format)
  def edit
    @letter = Letter.find(params[:id])
    @segments = @letter.segments.order(:number)
    @segment_lengths = @letter.segment_lengths
  end

  #PATCH /letters/:id(.:format)
  def update
    letter = Letter.find(params[:id])
    letter.set_segment_order(JSON.parse(letter_params[:segment_order]))
    if letter.save
      flash[:success] = "Letter number #{params[:id]} updated"
      redirect_to letters_path
    else
      flash[:error] = "Error updating letter number #{params[:id]}"
      render :index
    end
  end

  #DELETE /letters/:id(.:format)      letters#destroy
  def destroy
    letter = Letter.find(params[:id])
    if sign.remove_letters(letter) && sign.save
      flash[:success] = "Letter number #{letter.number} deleted"
      redirect_to letters_path
    else
      flash[:error] = "Problem deleting letter #{params[:id]}"
      render :index
    end
  end

  #PUT /letters/update(.:format)
  def reload
    LedString.new.add_sign(sign)
    flash[:success] = 'Sign has been updated.'
    redirect_to letters_path
  end

  #segment_lengths_letter
  #PUT /letters/:id/segment_lengths(.:format)
  def segment_lengths
    @letter = Letter.find(params[:id])
    @letter.segment_lengths = JSON.parse(segment_lengths_params)
    redirect_to edit_letter_path(@letter)
  end

  private

    def letter_params
      params.require(:letter).permit(:segment_order)
    end

    def segment_lengths_params
      params.require(:segment_lengths)
    end

end
