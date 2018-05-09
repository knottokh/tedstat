class TaskresultsController < ApplicationController
      
  # POST /approve pending
  def createorupdate
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
     
     respond_to do |format|  
            format.html
            format.json { 
              render :json => {
                :results =>  issave
            } 
          }
     end
  end
end
