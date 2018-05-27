class TeachersController < ApplicationController
  before_action :authenticate_user!
  before_action :is_teacher!
  #before_action :set_variable,only: [:manage]
  
  # GET /teacher_dashboard
  def index
    set_variable
  end
  # POST /managecourse
  def indexpost
     set_variable
     render :index
     #redirect_to managecourse_path(:year => params[:year],:course => params[:course],:room => params[:room])
  end  
  # GET /managecourse
  def manage
    set_variable
  end
  # POST /managecourse
  def managepost
     set_variable
     render :manage
     #redirect_to managecourse_path(:year => params[:year],:course => params[:course],:room => params[:room])
  end  
  
  # GET /report
  def report
    set_variable
  end
  # POST /report
  def reportpost
     set_variable
     render :report
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
  
  # GET /reject pending
  def genmypin
     #@myrandom =  Digest::MD5.hexdigest("#{1}#{current_user.id}#{DateTime.now.to_s}")[0...6]
     #@myrandom = SecureRandom.hex(3)
     isfound = true
     myrandom = ""
     while isfound do
        myrandom = SecureRandom.hex(3).to_s
        finpin = Room.room_findbypin(myrandom)
        isfound = (finpin.length > 0)
     end

     respond_to do |format|  
            format.html
            format.json { 
              render :json => {
                :results =>  myrandom
            } 
          }
     end
  end
  
  def printreport
    @dataexcel = Array.new
    @sheetname = ""
    filename = "temp"
    @headerarr = Array.new
    @headerarr.push("ลำดับ")
    @headerarr.push(t("val.managecourse.code"))
    @headerarr.push(t("val.managecourse.fullname"))
    if !params[:room].nil? and !params[:course].nil?
      if params[:room].present? and params[:course].present? 
          approved = Scourse.scourse_approved(params[:course],params[:room])
          mytasks = Task.task_by_room(params[:course],params[:room])
          taskresults = Taskresult.taskresult_by_room(params[:course],params[:room])
          room = Room.joins(:course).select("*").find(params[:room])
          
          @sheetname  = room.room_name.replacespacial("_")
          filename = "#{room.couse_year} - #{room.couse_name} / #{room.room_name.replacespacial("-")}"
          #Loop header
          if !mytasks.nil? and !mytasks.empty?
            mytasks.each_with_index do |t,index|
                @headerarr.push("#{t.task_name}/ #{t.task_assessment}")
            end
          end  
          @headerarr.push(t("val.managecourse.scoretotal"))
          @headerarr.push(t("val.managecourse.scoreresult"))
          
          if !approved.nil? and !approved.empty? 
              approved.each_with_index do |rc,index|
                  new_data_has = Array.new
                  new_data_has.push((!rc.studenno.nil? ? rc.studenno : index + 1))
                  new_data_has.push(rc.student_code)
                  new_data_has.push("#{rc.prefix}#{rc.name}  #{rc.surname}")
                  if !mytasks.nil? and !mytasks.empty?
                      mytasks.each_with_index do |t,index|
                        default_score = nil
                        findt = taskresults.find {|s| s.task_id == t.tid &&  s.user_id == rc.uid}
                        if !findt.nil?
                           default_score = findt.score
                        end 
                        new_data_has.push(default_score)
                      end
                  end
                  
                  new_data_has.push(format('%.2f',rc.average_score))
                  new_data_has.push(rc.grade)
                  
                  @dataexcel.push(new_data_has)
              end  
          end  
          
      end 
    end

    #respond_to do |format|
    #  format.html
    #  format.xlsx
    #end
    respond_to do |format|
      format.html
      format.xlsx do
        response.headers['Content-Disposition'] = 'attachment; filename="' + filename + '.xlsx"'
        render "teachers/printreport.xlsx"
      end  
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
  def set_variable
      set_master_layout(1)
      @years = Course.select(:couse_year).where(:user_id => current_user.id).group(:couse_year).order("couse_year desc")
      @courses = []
      @rooms = []
      @roombyid = nil
      
      #@pendingapprove = []
      
      @isparamcorrect = false
      
      #@courses = Course.where(:couse_year => 2561)
      #@rooms = Room.where(:course_id => 10)
      #@pendingapprove = Scourse.scourse_pending(10,1)
      if params[:year].present?
        @courses = Course.where(:couse_year => params[:year],:user_id => current_user.id)
      end
      if params[:course].present?
        #room_course_user(params[:course],current_user.id)
        @rooms = Room.where(:course_id => params[:course])
        flash[:course] = params[:course]
      end
      if params[:room].present? and params[:course].present? 
          @isparamcorrect = true
          @roombyid  = Room.find(params[:room].to_i)
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
