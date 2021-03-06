class OthermodalsController < ApplicationController
  respond_to :html, :json
  def infostudent
    @stuuser = User.find(params[:uid])
    room = Room.find(params[:rid])
    @myroom = room
    @mycourse = Course.find(room.course_id)
    
    @taskforgraph = Taskresult.taskresult_scoreonly_course_room_user(room.course_id,room.id,@stuuser.id)
    task_data_myscore = Hash.new
    task_data_avgscore = Hash.new
    @taskforgraph.each do |tfg|
              scorejson = JSON.parse(tfg.task_behavior_extra)
              maxscore = 1.0
              if !scorejson["score"].empty?
                  maxscore = scorejson["score"].to_f
              end      
              task_data_myscore["#{tfg.task_name}/#{tfg.task_assessment}"] = (tfg.score.to_f / maxscore ) * 100
              task_data_avgscore["#{tfg.task_name}/#{tfg.task_assessment}"] = (tfg.average_score.to_f / maxscore) * 100
    end 
    #task_data = Hash.new
    #task_data[:myscore] = @taskforgraph.map{|t| [t.task_name, t.score.to_f] }
    #task_data[:averagescore] = @taskforgraph.map{|t| [t.task_name, t.average_score] }
    @task_datas =[{"name" => t("val.student.myscroe"),"data" => task_data_myscore},{"name" => t("val.student.avgscore"),"data" => task_data_avgscore}]
    
    @finishedtask = Taskresult.taskresult_notnull(room.course_id,room.id,@stuuser.id)
    @finished_task_id = @finishedtask.each{ |m| m.tid }.to_a
    @unfinishtask = Task.task_by_room_notin(room.course_id,room.id,@finished_task_id)
    
    
          
    respond_modal_with @stuuser , location: managecourse_path
  end
end
