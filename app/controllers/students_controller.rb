class StudentsController < ApplicationController
    before_action :authenticate_user!
    before_action :is_student! 
    def index
        @course = []
        @currentpin = 0
        @rcourses = Scourse.scourse_findbyuser(current_user.id)
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
end
