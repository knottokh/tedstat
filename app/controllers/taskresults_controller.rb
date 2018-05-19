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
     
     # totalscore and grade - scourses
     
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
  def createorupdatetext
     # my score - taskresult
     taskresulst = Taskresult.where(:user_id => params[:user_id].to_i , :task_id => params[:task_id].to_i).first
     if taskresulst.nil?
         taskresulst = Taskresult.create(taskresult_params)
     else     
         taskresulst.update(taskresult_params)
     end     
     issave = taskresulst.save
     
     # average task score - tasks
     
     # totalscore and grade - scourses
     
     respond_to do |format|  
            format.html
            format.json { 
              render :json => {
                :results =>  issave
            } 
          }
     end
  end
  def taskresult_params
    params.permit(:user_id,:task_id,:score,:quality,:advantage,:disadvantage,:suggestion,:remark)
  end 
end
