class StudentsController < ApplicationController
    before_action :authenticate_user!
    before_action :is_student! 
    before_action :set_variable,only: [:index]
    def index
        @course = []
        @currentpin = 0
        @pendingcourses = Scourse.scourse_findbyuser(current_user.id).where(:status => "pending")
        @approvecourses = Scourse.scourse_findbyuser(current_user.id).where(:status => "approved")
        if params[:course_pin].present?
            @course = Room.room_findbypin(params[:course_pin])
            sc  = Scourse.scourse_findbypin(current_user.id,params[:course_pin])
            if !sc.nil?
                @currentpin = sc.count
            end
        end  
        if @currentpin > 0
             @course = []
        end
        
    end
    
    def createrequest
        msg = ""
        req  = Scourse.create({room_id: params[:r_id],course_id: params[:c_id],user_id: current_user.id})
        if req.save
            msg  = "Request Success"
        else    
            msg = "Request Fails"
        end
        redirect_to student_dashboard_path , alert: msg
    end
    
    # POST /Save User Emotion
      def addemotion
         #emd = Emotion.where(:room_id => params[:room],:course_id => params[:course],:user_id => current_user.id,:created_at => Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).first
         emd = Emotion.find_by_user_room_course_created(params[:course],params[:room],current_user.id).first
         issave = false
         created = ""
         if emd.nil?
             newemo = Emotion.create({:emotion => params[:emo],:room_id => params[:room],:course_id => params[:course],:user_id => current_user.id })
             issave = newemo.save
             created = newemo.created_at.to_s
         else
             emd.update({:emotion => params[:emo]})
             issave = emd.save
             created = emd.created_at.to_s
         end     
         #ud.update({:status => "approved"})
          #ud.save
         
         respond_to do |format|  
                format.html
                format.json { 
                  render :json => {
                    :results =>  {:save => issave , :created => created}
                } 
              }
         end
      end
    
    private
        def set_variable
            set_master_layout(1)
        end
end
