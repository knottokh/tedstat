class ScoresController < ApplicationController
  before_action :set_room, only: [:edit, :update]
  respond_to :html, :json
  def edit
    @calulateexam = Task.task_by_room_exam(params[:id].to_i)
    @calulatesaving = Task.task_by_room_saving(params[:id].to_i)
    @grades = [
      ["A,B,C (4 ระดับ)",1],
      ["A,B,C (8 ระดับ)",2],
      ["1,2,3 (4 ระดับ)",3],
      ["1,2,3 (8 ระดับ)",4],
    ]
    respond_modal_with @room
  end
  
  def update
    params.permit!
    @room.update(room_params)
    respond_modal_with @room , location: managecourse_path
  end
  
  private
    def set_room
      @room = Room.find(params[:id])
    end
    def room_params
      params.require(:room).permit(:point_attr,:ratio_score,:ratio_grade)
    end  
end
