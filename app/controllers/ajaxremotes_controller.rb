class AjaxremotesController < ApplicationController
  respond_to :html, :json
  
  #GET show approve
  def showapproved
    @approved = []
    @mytasks = []
    @taskresults = []
    if params[:room].present? and params[:course].present? 
        @approved = Scourse.scourse_approved(params[:course],params[:room])
        @mytasks = Task.task_by_room(params[:course],params[:room])
        @taskresults = Taskresult.taskresult_by_room(params[:course],params[:room])
    end 
    
    respond_empty_with @approved
  end
  
  #GET show pending
  def showpending
    @pendings = []
    if params[:room].present? and params[:course].present? 
        @pendings = Scourse.scourse_pending(params[:course],params[:room])
    end 
    
    respond_empty_with @pendings
  end
end
