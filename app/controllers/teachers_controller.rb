class TeachersController < ApplicationController
  before_action :authenticate_user!
  before_action :is_teacher!
  before_action :set_variable,only: [:manage]
  
  # GET /teacher_dashboard
  def index
  end
  
  # GET /managecourse
  def manage
   
  end
  # POST /managecourse
  def managepost
     set_variable
     render :manage
     #redirect_to managecourse_path(:year => params[:year],:course => params[:course],:room => params[:room])
  end  

  # POST /approve pending
  def approvepost
     ud = Scourse.find(params[:id].to_i)
     ud.update({:status => "approved"})
     issave = ud.save
     
     respond_to do |format|  
            format.html
            format.json { 
              render :json => {
                :results =>  issave
            } 
          }
     end
  end
  
  # POST /reject pending
  def rejectpost
     ud = Scourse.find(params[:id].to_i)
     ud.update({:status => "rejected"})
     issave = ud.save
     
     respond_to do |format|  
            format.html
            format.json { 
              render :json => {
                :results =>  issave
            } 
          }
     end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
  def set_variable
      @years = Course.select(:couse_year).group(:couse_year).order("couse_year desc")
      @courses = []
      @rooms = []
      
      #@pendingapprove = []
      
      @testtrue = false
      
      #@courses = Course.where(:couse_year => 2561)
      #@rooms = Room.where(:course_id => 10)
      #@pendingapprove = Scourse.scourse_pending(10,1)
      if params[:year].present?
        @courses = Course.where(:couse_year => params[:year])
      end
      if params[:course].present?
        @rooms = Room.where(:course_id => params[:course])
        flash[:course] = params[:course]
      end
      if params[:room].present? and params[:course].present? 
          @testtrue = true
          #@pendingapprove = Scourse.scourse_pending(params[:course],params[:room])
          flash[:room] = params[:room]
      end  
      
      if request.xhr?
        respond_to do |format|
          format.json {
            render json: {
                years: @years,
                courses: @courses,
                rooms: @rooms
            }
          }
        end
      end
  end
end
