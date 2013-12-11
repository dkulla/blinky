class SegmentsController < ApplicationController
  def update
    segment = Segment.find(params[:id])
    if segment.update_attributes(segment_params)
      flash[:success] = 'Segment Updated'
    else
      flash[:error] = 'Error updating segment.'
    end
    redirect_to edit_letter_path(segment.letter)
  end

  private

  def segment_params
    params.require(:segment).permit(:length)
  end
end
