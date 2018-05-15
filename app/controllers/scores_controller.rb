class ScoresController < ApplicationController
  respond_to :html, :json
  def edit
    @room = Room.find(params[:id].to_i)
    respond_modal_with @room
  end
  
  def update
    @room = Room.find(params[:id].to_i).update(room_update_params)
    respond_modal_with @room , location: managecourse_path
  end
  
  private
  def room_update_params
    params.require(:task).permit(:attribute_point, :ratio_score,:ratio_grade)
  end  
end
