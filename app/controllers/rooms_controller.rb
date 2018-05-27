class RoomsController < ApplicationController
    respond_to :html, :json

  def new
    @room = Room.new
    @courses = Course.where(:user_id => current_user.id)
    respond_modal_with @room
  end

  def create
    @room = Room.create(room_params)
    respond_modal_with @room , location: managecourse_path
  end
  
  def edit
    @room = Room.find(params[:id].to_i)
    @courses = Course.where(:user_id => current_user.id)
    respond_modal_with @room
  end
  
  def editscore
    @room = Room.find(params[:id].to_i)
    @calulateexam = Task.task_by_room_exam(params[:id].to_i)
    @calulatesaving = Task.task_by_room_saving(params[:id].to_i)
    @grades = [
      ["A,B,C (4 ระดับ)",1],
      ["A,B,C (8 ระดับ)",2],
      ["1,2,3 (4 ระดับ)",3],
      ["1,2,3 (8 ระดับ)",4],
    ]
    params[:isscoreedit] = true
    respond_modal_with @room
  end

  def update
    @room = Room.find(params[:id].to_i).update((params[:isscoreedit] == "true") ? score_params : room_params)
    if params[:iseditscore].to_s == "true"
      curroom = Room.find(params[:id].to_i)
      approved = Scourse.scourse_approved(curroom.course_id,curroom.id)
      mytasks = Task.task_by_room(curroom.course_id,curroom.id)
      approved.each do |app|
        mytasks.each do |mt|
          update_score_gread_per_user(mt.tid,app.uid)
        end
      end
      #updateresult = update_score_gread_per_user(params[:task_id].to_i,params[:user_id].to_i)
    end
    params[:isscoreedit] = params[:isscoreedit]
    respond_modal_with @room , location: managecourse_path
  end
  private

  def room_params
    params.require(:room).permit(:room_name, :room_detail,:room_pin,:course_id)
  end 
  def score_params
    params.require(:room).permit(:point_attr,:ratio_score,:ratio_grade)
  end 
end
