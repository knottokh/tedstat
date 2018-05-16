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
  
  #GET show pending
  def showmycourse
    @emotion = [:good,:nomal,:bad]
    @mytasks = []
    @taskresults = []
    if !params[:room].nil? and !params[:course].nil?
      if params[:room].present? and params[:course].present? 
          @mytasks = Task.task_by_room(params[:course],params[:room])
          @taskresults = Taskresult.taskresult_by_room_user(params[:course],params[:room],current_user.id)
          #@taskresults = Taskresult.taskresult_by_room(params[:course],params[:room])
      end 
    end
    
    respond_empty_with @mytasks
  end
end
