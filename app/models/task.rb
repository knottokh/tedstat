class Task < ApplicationRecord
    scope :task_by_room ,-> (cid,rid){
            joins(:course,:room).select("*,tasks.id tid,courses.id cid,rooms.id rid").where(:room_id => rid,:course_id => cid)
    }
    scope :task_by_room_exam ,-> (rid){
            joins(:course,:room).select("*,tasks.id tid,courses.id cid,rooms.id rid").where(:room_id => rid)
            .where("task_behavior = 'คะแนน (scoring)' OR task_behavior = 'rating scale'")
            .where("task_assessment = 'สอบกลางภาค' OR task_assessment = 'สอบปลายภาค'")
    }
    scope :task_by_room_saving,-> (rid){
            joins(:course,:room).select("*,tasks.id tid,courses.id cid,rooms.id rid").where(:room_id => rid)
            .where("task_behavior = 'คะแนน (scoring)' OR task_behavior = 'rating scale'")
            .where.not("task_assessment = 'สอบกลางภาค' OR task_assessment = 'สอบปลายภาค'")
    }
    validates :course_id, presence: true
    validates :room_id, presence: true
    validates :task_name, presence: true
    validates :task_detail, presence: true
    validates :task_assessment, presence: true
    validates :task_behavior, presence: true
    validates :task_feedback, presence: true
    
    belongs_to :course 
    belongs_to :room 
    has_many :taskresults
end
