class FeedbacksController < ApplicationController
  respond_to :html, :json
  def new
    @feedback = Feedback.new(:taskresult_id => params[:taskresult_id])
    @mytaskresult = Taskresult.taskresult_by_id(params[:taskresult_id])
    @allfeddback = Feedback.feedback_by_user(params[:taskresult_id],current_user.id)
    respond_modal_with @feedback
  end
  
  def create
    defaultdata = { "user_id" => current_user.id}
    @feedback = Feedback.create(feedback_params.merge(defaultdata))
    respond_modal_with @feedback , location: student_dashboard_path
  end
  
  private
  def feedback_params
    params.require(:feedback).permit(:feed_text,:taskresult_id)
  end 

end
