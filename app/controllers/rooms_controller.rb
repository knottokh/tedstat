class RoomsController < ApplicationController
    respond_to :html, :json

  def new
    @room = Room.new
    @courses = Course.all
    respond_modal_with @room
  end

  def create
    @room = Room.create(room_params)
    respond_modal_with @room , location: managecourse_path
  end
  
  def edit
    @room = Room.find(params[:id].to_i)
    @courses = Course.all
    respond_modal_with @room
  end

  def update
    @room = Room.find(params[:id].to_i).update(room_params)
    respond_modal_with @room , location: managecourse_path
  end
  private

  def room_params
    params.require(:room).permit(:room_name, :room_detail,:room_pin,:course_id)
  end   
end
