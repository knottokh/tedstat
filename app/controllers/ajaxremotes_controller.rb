class AjaxremotesController < ApplicationController
  respond_to :html, :json
  
  #GET show approve
  def showapproved
    @approved = []
    @mytasks = []
    @taskresults = []
    @isparamcorrect = false
    if !params[:room].nil? and !params[:course].nil?
      if params[:room].present? and params[:course].present? 
          @approved = Scourse.scourse_approved(params[:course],params[:room])
          @mytasks = Task.task_by_room(params[:course],params[:room])
          @taskresults = Taskresult.taskresult_by_room(params[:course],params[:room])
          flash[:course] = params[:course]
          flash[:room] = params[:room]
          @isparamcorrect = true
          room = Room.find(params[:room])
          @attrpoint = room.point_attr
      end 
    end
    
    respond_empty_with @approved
  end
  
  #GET show pending
  def showpending
    @pendings = []
    @isparamcorrect = false
    if params[:room].present? and params[:course].present? 
        @pendings = Scourse.scourse_pending(params[:course],params[:room])
        flash[:course] = params[:course]
        flash[:room] = params[:room]
        @isparamcorrect = true
    end 
    
    respond_empty_with @pendings
  end
  
  #GET show graph
  def showgraph
    @mytasks = Array.new
    @isparamcorrect = false
    if !params[:room].nil? and !params[:course].nil?
      if params[:room].present? and params[:course].present? 
          approved = Scourse.scourse_approved(params[:course],params[:room])
          @mytasks = Task.task_by_room(params[:course],params[:room])
          #taskresults = Taskresult.taskresult_by_room(params[:course],params[:room])
          task_data = Array.new
          approved.each do |app|
              usertask_data = Hash.new
              usertask_data[:fullname] = "#{app.prefix}#{app.name}  #{app.surname}"
              score_data = Array.new
              @mytasks.each do |mt|
                  taskr = Hash.new
                  if mt.task_behavior == "คะแนน (scoring)" or mt.task_behavior == "rating scale"
                     maxscore = JSON.parse(mt.task_behavior_extra)["score"].to_i  
                     min = 0
                     if mt.task_behavior == "rating scale"
                      min = 1
                     end  
                     mid = (maxscore + min ) / 2.0
                     rang = (maxscore - min) / 6.0
                     ul = mid - rang
                     uu = mid + rang
                     taskr[:mid] = mid
                     taskr[:max] = maxscore
                     taskr[:max] = min
                     taskr[:upper] = uu
                     taskr[:lower] = ul
                     usertask = Taskresult.taskresult_scoreonly_user(mt.tid,app.uid).first
                     if !usertask.nil?
                        uscore  = usertask.score.to_i
                        if uscore < ul
                            taskr[:color] = "r"
                        elsif uscore >= ul and uscore <= uu
                            taskr[:color] = "y"
                        else
                            taskr[:color] = "b"
                        end
                     else
                        taskr[:color] = "0"
                     end 
                  elsif  mt.task_behavior == "checklist"
                       behav_json = JSON.parse(mt.task_behavior_extra) 
                       maxscore = behav_json["data"].length
                       min = 0
                       mid = (maxscore + min ) / 2.0
                       rang = (maxscore - min) / 6.0
                       ul = mid - rang
                       uu = mid + rang
                       taskr[:mid] = mid
                       taskr[:max] = maxscore
                       taskr[:max] = min
                       taskr[:upper] = uu
                       taskr[:lower] = ul
                      
                       utask_checklist = Taskresult.taskresult_scoreochecklist_user(mt.tid,app.uid).first
                       if !utask_checklist.nil?
                          uscore = 0
                          stringss = ""
                          uscorearr  = utask_checklist.score.split(",")
                          behav_json["data"].each do |carr|
                            fex1 = uscorearr.index(carr["value1"])
                            fex2 = uscorearr.index(carr["value2"])
                            if !fex1.nil?
                                 uscore += 1
                            end 
                            if !fex2.nil?
                                 uscore += 0
                            end
                          end 
                          #taskr[:color] = "s#{uscore}-#{uscorearr}-#{utask_checklist.trid}"
                          if uscore < ul
                              taskr[:color] = "r"
                          elsif uscore >= ul and uscore <= uu
                              taskr[:color] = "y"
                          else
                              taskr[:color] = "b"
                          end
                       else
                          taskr[:color] = "0"
                       end 
                  else
                    taskr[:color] = "0"
                  end  
                   score_data.push(taskr)
              end 
              usertask_data[:taskresult] = score_data
              avgscore = app.average_score
              if app.is_point_attr
                  avgscore -= app.point_attr.to_i
              end
              usertask_data[:avgscore] = avgscore
              task_data.push(usertask_data)
          end  
          @graphresult = task_data
          flash[:course] = params[:course]
          flash[:room] = params[:room]
          @isparamcorrect = true
      end 
    end
    
    respond_empty_with @graphresult
  end
  #GET show pending
  def showmycourse
    @emotion = [:good,:nomal,:bad]
    @curemotion = ""
    @showemo = false
    @mytasks = []
    @taskresults = []
    if !params[:room].nil? and !params[:course].nil?
      if params[:room].present? and params[:course].present? 
          @mytasks = Task.task_by_room(params[:course],params[:room])
          @taskresults = Taskresult.taskresult_by_room_user(params[:course],params[:room],current_user.id)
          findemo  = Emotion.find_by_user_room_course_created(params[:course],params[:room],current_user.id).first
          if !findemo.nil?
            cour = Course.find(params[:course].to_i) 
            @currentcousename = cour.couse_name
            @curemotion = findemo.emotion.to_s
          end
          #@taskresults = Taskresult.taskresult_by_room(params[:course],params[:room])
          @showemo  = true
          taskforgraph = Taskresult.taskresult_scoreonly_user(params[:course],params[:room],current_user.id)
          task_data_myscore = Hash.new
          task_data_avgscore = Hash.new
          taskforgraph.each do |tfg|
              scorejson = JSON.parse(tfg.task_behavior_extra)
              maxscore = 1.0
              if !scorejson["score"].empty?
                  maxscore = scorejson["score"].to_f
              end      
              task_data_myscore["#{tfg.task_name}/#{tfg.task_assessment}"] = (tfg.score.to_f / maxscore ) * 100
              task_data_avgscore["#{tfg.task_name}/#{tfg.task_assessment}"] = (tfg.average_score.to_f / maxscore) * 100
          end 
          #task_data = Hash.new
          #task_data[:myscore] = taskforgraph.map{|t| [t.task_name, t.score.to_f] }
          #task_data[:averagescore] = taskforgraph.map{|t| [t.task_name, t.average_score] }
          @task_datas =[{"name" => t("val.student.myscroe"),"data" => task_data_myscore},{"name" => t("val.student.avgscore"),"data" => task_data_avgscore}]
          
          #[{ 'Male' => task_data[:myscore], 'Female' => task_data[:averagescore] }]
          params[:course] = params[:course]
          params[:room] = params[:room]
      end 
    end
    
    respond_empty_with @mytasks
  end
end
