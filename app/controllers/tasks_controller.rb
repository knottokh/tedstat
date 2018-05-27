class TasksController < ApplicationController
  before_action :set_parameter, only: [:new,:edit]
  respond_to :html, :json

  def new
    @task = Task.new
    respond_modal_with @task
  end

  def create
    @task = Task.create(task_params)
    respond_modal_with @task , location: managecourse_path
  end
  
  def edit
    @task = Task.find(params[:id].to_i)
    @approved = Scourse.scourse_approved(@task.course_id,@task.room_id)
    @taskresults = Taskresult.taskresult_by_taskid(params[:id].to_i)
    @studenfeedback = Feedback.where(:task_id => params[:id].to_i)
    respond_modal_with @task
  end

  def update
    if !params[:isdelete].nil? and params[:isdelete].present? and params[:isdelete].to_s == "true"
       @task = Task.find(params[:id].to_i).delete
    else
     @task = Task.find(params[:id].to_i).update(task_update_params)
    end
    respond_modal_with @task , location: managecourse_path
  end

  private
  def set_parameter
        @assessments = ["การบ้าน",
                      "แบบฝึกหัด",
                      "กิจกรรมชั้นเรียน",
                      "ปฏิบัติการ",
                      "ทดสอบย่อย",
                      "โครงงาน",
                      "กิจกรรมกลุ่ม",
                      "สอบกลางภาค",
                      "สอบปลายภาค",
                      "อื่นๆ"]
        @behabior = [
              "คะแนน (scoring)",
              "rating scale",
              "checklist",
              "ข้อความ"
          ]              
  end
  def task_params
    params.require(:task).permit(:course_id,:room_id,:task_name, :task_detail,:task_assessment,:task_assignment_other,:task_behavior,:task_behavior_extra,:task_feedback,:task_duedate,:task_alert)
  end   
  def task_update_params
    params.require(:task).permit(:task_name, :task_detail,:task_assessment,:task_assignment_other,:task_behavior,:task_behavior_extra,:task_feedback,:task_duedate,:task_alert)
  end  
end
