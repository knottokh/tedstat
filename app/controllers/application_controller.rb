class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  
  protect_from_forgery with: :exception
  
  
  private
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:school_id,:password,:password_confirmation,
                        :prefix,:name,:surname,:student_code,:role,:email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:school_id,:password,:password_confirmation,
                        :prefix,:name,:surname,:student_code,:role,:email])
  end
  def set_locale
    session[:locale] = "th"
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
  end
  
  def set_master_layout(val)
      @master_layout  = val
  end      
  def check_user_home!
    if !current_user.nil?
      if current_user.student? 
        #sign_out(current_user)
        redirect_to student_dashboard_path
      elsif current_user.teacher? 
          redirect_to teacher_dashboard_path
      end 
    end
  end
  def is_teacher!
    if !current_user.teacher? 
      #sign_out(current_user)
      redirect_to root_path ,notice: "You trying to access without permission role Teacher!"
    end 
  end
  def is_student!
    if !current_user.student? 
      #sign_out(current_user)
      redirect_to root_path ,notice: "You trying to access without permission role Student!"
    end 
  end
  def update_score_gread_per_user_all(courseid,roomid,userid)
     #taskaverage = Task.find(taskid)
     room = Room.find(roomid)
     suercourse = Scourse.scourse_findby_user_course_room(courseid,roomid,userid).first
     ratio_scorejson = JSON.parse(room.ratio_score)
     ratio_gradejson = JSON.parse(room.ratio_grade)
     studenfinalscore = 0.0
     sscore = Array.new
     ratio_scorejson["results"].each do |rs|
        maxscorepercent = rs["maxscore"]["score"].to_i
        sumbypercent = 0
        rs["maxscore"]["childs"].each do |c|
            curscorepercent = c["score"].to_f
            studentask = Taskresult.taskresult_by_task_user(c["id"],userid).first
            if !studentask.nil?
                curbehave = JSON.parse(studentask.task_behavior_extra)["score"].to_f
                sumbypercent +=  ((studentask.score.to_i / curbehave ) * curscorepercent)
            end  
        end 
        studenfinalscore += (sumbypercent * (maxscorepercent / 100.00))
     end   
     # add point attr
     if !suercourse.nil? and suercourse.is_point_attr
        studenfinalscore += room.point_attr
     end     
     # grade compare
     mygrade = ""
     ratio_gradejson["blocks"].each do |blk|
        iscurrentgrade = true
        leftscore = blk["leftnum"].to_i
        leftoper = blk["leftoper"]
        rightscore = blk["rightnum"].to_i
        rightoper = blk["rightoper"]
        iscurrentgrade &= check_number_with_operate(studenfinalscore,rightoper,rightscore)
        iscurrentgrade &= check_number_with_operate(leftscore,leftoper,studenfinalscore)
        if iscurrentgrade
          mygrade = blk["gtext"]
          break
        end
     end
     if !suercourse.nil?
        updatescourse = Scourse.find(suercourse.scid)
        updatescourse.update({:average_score => studenfinalscore,:grade => mygrade})
        isupdatescore  = updatescourse.save
     end 
     return {
       :saved => (isupdatescore),
       :score => format('%.2f',studenfinalscore),
       :grade => mygrade,
     }
  end
  def update_score_gread_per_user(taskid,userid)
     taskaverage = Task.find(taskid)
     room = Room.find(taskaverage.room_id)
     suercourse = Scourse.scourse_findby_user_course_room(taskaverage.course_id,taskaverage.room_id,userid).first
     ratio_scorejson = JSON.parse(room.ratio_score)
     ratio_gradejson = JSON.parse(room.ratio_grade)
     studenfinalscore = 0.0
     sscore = Array.new
     ratio_scorejson["results"].each do |rs|
        maxscorepercent = rs["maxscore"]["score"].to_i
        sumbypercent = 0
        rs["maxscore"]["childs"].each do |c|
            curscorepercent = c["score"].to_f
            studentask = Taskresult.taskresult_by_task_user(c["id"],userid).first
            if !studentask.nil?
                curbehave = JSON.parse(studentask.task_behavior_extra)["score"].to_f
                sumbypercent +=  ((studentask.score.to_i / curbehave ) * curscorepercent)
            end  
        end 
        studenfinalscore += (sumbypercent * (maxscorepercent / 100.00))
     end   
     # add point attr
     if !suercourse.nil? and suercourse.is_point_attr
        studenfinalscore += room.point_attr
     end     
     # grade compare
     mygrade = ""
     ratio_gradejson["blocks"].each do |blk|
        iscurrentgrade = true
        leftscore = blk["leftnum"].to_i
        leftoper = blk["leftoper"]
        rightscore = blk["rightnum"].to_i
        rightoper = blk["rightoper"]
        iscurrentgrade &= check_number_with_operate(studenfinalscore,rightoper,rightscore)
        iscurrentgrade &= check_number_with_operate(leftscore,leftoper,studenfinalscore)
        if iscurrentgrade
          mygrade = blk["gtext"]
          break
        end
     end
     if !suercourse.nil?
        updatescourse = Scourse.find(suercourse.scid)
        updatescourse.update({:average_score => studenfinalscore,:grade => mygrade})
        isupdatescore  = updatescourse.save
     end 
     return {
       :saved => (isupdatescore),
       :score => format('%.2f',studenfinalscore),
       :grade => mygrade,
     }
  end
  def check_number_with_operate(lnum,oper,rnum)
      iscurrentgrade = true
      if oper == "<="
          iscurrentgrade &= (lnum <= rnum)
      elsif oper == "<"
          iscurrentgrade &= (lnum < rnum)
      else
          iscurrentgrade &= false
      end
      iscurrentgrade
  end
  def importfile(model,accessible_attributes=nil,file)
      spreadsheet = open_spreadsheet(file)
      desired_columns = accessible_attributes || model.column_names
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        improtmol = model.find_by_id(row["id"]) || model.new
        improtmol.attributes = row.to_hash.slice(*desired_columns)
        improtmol.save!
      end
  end
    
  def open_spreadsheet(file)
      case File.extname(file.original_filename)
       when '.csv' then Roo::Csv.new(file.path)
       when '.xls' then Roo::Excel.new(file.path)
       when '.xlsx' then Roo::Excelx.new(file.path)
       else raise "Unknown file type: #{file.original_filename}"
      end
  end
  def respond_modal_with(*args, &blk)
    options = args.extract_options!
    options[:responder] = ModalResponder
    respond_with *args, options, &blk
  end
  def respond_empty_with(*args, &blk)
    options = args.extract_options!
    options[:responder] = EmptyResponder
    respond_with *args, options, &blk
  end
end
class String
  def replacespacial(s = ' ')
    self.gsub(/([@#!%()=;><,{}\~\[\]\/\?\"\*\^\$]+)/, s)
  end
end