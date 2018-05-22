class CoursesController < ApplicationController
  respond_to :html, :json

  def new
    @course = Course.new
    respond_modal_with @course
  end

  def create
    @course = Course.create(course_params)
    respond_modal_with @course , location: managecourse_path
  end
  
  def edit
    @course = Course.find(params[:id].to_i)
    respond_modal_with @course
  end

  def update
    @course = Course.find(params[:id].to_i).update(course_params)
    respond_modal_with @course , location: managecourse_path
  end
  private

  def course_params
    params.require(:course).permit(:couse_name,:couse_year,:couse_detail,:user_id)
  end   
end
