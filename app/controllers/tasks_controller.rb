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
    respond_modal_with @task
  end

  def update
    @task = Task.find(params[:id].to_i).update(task_update_params)
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
    params.require(:task).permit(:course_id,:room_id,:task_name, :task_detail,:task_assessment,:task_behavior,:task_feedback,:task_duedate,:task_alert)
  end   
  def task_update_params
    params.require(:task).permit(:task_name, :task_detail,:task_assessment,:task_behavior,:task_feedback,:task_duedate,:task_alert)
  end  
end
