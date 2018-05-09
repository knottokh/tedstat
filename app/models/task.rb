class Task < ApplicationRecord
    scope :task_by_room ,-> (cid,rid){
            joins(:course,:room).select("*,tasks.id tid").where(:room_id => rid,:course_id => cid)
    }
  
    validates :course_id, presence: true
    validates :room_id, presence: true
    validates :task_name, presence: true
    validates :task_detail, presence: true
    validates :task_assessment, presence: true
    
    belongs_to :course 
    belongs_to :room 
end
