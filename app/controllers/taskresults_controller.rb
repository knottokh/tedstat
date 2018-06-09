class TaskresultsController < ApplicationController
      
  # POST /approve pending
  def createorupdate
     # my score - taskresult
     taskresulst = Taskresult.where(:user_id => params[:user_id].to_i , :task_id => params[:task_id].to_i).first
     if taskresulst.nil?
         taskresulst = Taskresult.create({
                :score => params[:score],
                :user_id => params[:user_id],
                :task_id => params[:task_id]
         })
     else     
         taskresulst.update({:score => params[:score]})
     end     
     issave = taskresulst.save
     

      # average task score - tasks
     taskresultall = Taskresult.taskresult_scoreonly(params[:task_id].to_i)
     taskavg = Task.find(params[:task_id].to_i)
     if !taskresultall.nil? && !taskresultall.empty? 
        sum = 0.0
        count = 0
        taskresultall.each do |ts|
            sum += ts.score.to_i
            count += 1
        end  
        taveg =  (sum / count)
        taskavg.update({:average_score => taveg})
        issum  = taskavg.save
     end   
     
     updateresult = update_score_gread_per_user(params[:task_id].to_i,params[:user_id].to_i)
     updateresult[:saved] = (issave && issum && updateresult[:saved])
     
     respond_to do |format|  
            format.html
            format.json { 
              render :json => {
                :results =>  updateresult
            } 
          }
     end
  end
  # POST /approve pending
  def createorupdatetext
     # my score - taskresult
     taskresulst = Taskresult.where(:user_id => params[:user_id].to_i , :task_id => params[:task_id].to_i).first
     if taskresulst.nil?
         taskresulst = Taskresult.create(taskresult_params)
     else     
         taskresulst.update(taskresult_params)
     end     
     issave = taskresulst.save
     
     respond_to do |format|  
            format.html
            format.json { 
              render :json => {
                :results =>  issave
            } 
          }
     end
  end
  
  # POST /approve pending
  def createorupdatepoint

     # totalscore and grade - scourses
     taskaverage = Task.find(params[:task_id].to_i)
     uscoure = Scourse.scourse_findby_user_course_room(taskaverage.course_id,taskaverage.room_id,params[:user_id].to_i).first
     
     if !uscoure.nil?
        upontscoure = Scourse.find(uscoure.scid)
        upontscoure.update({:is_point_attr => (params[:is_point_attr] == "true" ? true : false)})
        issave  = upontscoure.save
     end 
     
     updateresult = update_score_gread_per_user(params[:task_id].to_i,params[:user_id].to_i)
     updateresult[:saved] = (issave && updateresult[:saved])
     respond_to do |format|  
            format.html
            format.json { 
              render :json => {
                :results =>  updateresult
            } 
          }
     end
  end
  def createorupdatepointall
     successupdate = true
     if !params[:pttr_select].nil? and params[:pttr_select].present?  and
         !params[:course_id].nil? and params[:course_id].present?  and
         !params[:room_id].nil? and params[:room_id].present?  
     # totalscore and grade - scourses
         #taskaverage = Task.find(params[:task_id].to_i)
         approved = Scourse.scourse_approved(params[:course_id],params[:room_id])
         
         approved.each do |uscoure|
             #uscoure = Scourse.scourse_findby_user_course_room(params[:course_id],params[:room_id],appu.uid).first
             
             if !uscoure.nil?
                upontscoure = Scourse.find(uscoure.scid)
                upontscoure.update({:is_point_attr => (params[:pttr_select] == "true" ? true : false)})
                issave  = upontscoure.save
             end 
             
             updateresult = update_score_gread_per_user_all(params[:course_id],params[:room_id],uscoure.uid)
             successupdate = (issave && updateresult[:saved])
          end
     end
     respond_to do |format|  
            format.html
            format.json { 
              render :json => {
                :results =>  successupdate
            } 
          }
     end
  end
  private
    def taskresult_params
      params.permit(:user_id,:task_id,:score,:quality,:advantage,:disadvantage,:suggestion,:remark)
    end 
end
