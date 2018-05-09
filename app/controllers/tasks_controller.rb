class TasksController < ApplicationController
  respond_to :html, :json

  def new
    @task = Task.new
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
    respond_modal_with @task
  end

  def create
    @task = Task.create(task_params)
    respond_modal_with @task , location: managecourse_path
  end

  private

  def task_params
    params.require(:task).permit(:course_id,:room_id,:task_name, :task_detail,:task_assessment)
  end   
end
