class Task < ApplicationRecord
    scope :task_by_room ,-> (cid,rid){
            joins(:course,:room).select("*,tasks.id tid,courses.id cid,rooms.id rid").where(:room_id => rid,:course_id => cid).order("tasks.id asc")
    }
    scope :task_by_room_notin ,-> (cid,rid,idarr){
            joins(:course,:room).select("*,tasks.id tid,courses.id cid,rooms.id rid").where(:room_id => rid,:course_id => cid)
            .where("tasks.id NOT IN (?)",idarr).order("tasks.id asc")
    }
    scope :task_by_room_notext ,-> (cid,rid){
            joins(:course,:room).select("*,tasks.id tid,courses.id cid,rooms.id rid").where(:room_id => rid,:course_id => cid)
            .where("task_behavior = 'คะแนน (scoring)' OR task_behavior = 'rating scale' OR task_behavior = 'checklist'").order("tasks.id asc")
    }
    scope :task_by_room_exam ,-> (rid){
            joins(:course,:room).select("*,tasks.id tid,courses.id cid,rooms.id rid").where(:room_id => rid)
            .where("task_behavior = 'คะแนน (scoring)' OR task_behavior = 'rating scale'")
            .where("task_assessment = 'สอบกลางภาค' OR task_assessment = 'สอบปลายภาค'").order("tasks.id asc")
    }
    scope :task_by_room_saving,-> (rid){
            joins(:course,:room).select("*,tasks.id tid,courses.id cid,rooms.id rid").where(:room_id => rid)
            .where("task_behavior = 'คะแนน (scoring)' OR task_behavior = 'rating scale'")
            .where.not("task_assessment = 'สอบกลางภาค' OR task_assessment = 'สอบปลายภาค'").order("tasks.id asc")
    }
    scope :task_by_alert ,-> (ridarr,idarr){
            joins(:course,:room).select("*,tasks.id tid,courses.id cid,rooms.id rid")
            .where("tasks.task_alert <= ?",DateTime.now)
            .where("rooms.id IN (?)",ridarr)
            .where("tasks.id NOT IN (?)",idarr).order("tasks.id asc")
    }
    validates :course_id, presence: true
    validates :room_id, presence: true
    validates :task_name, presence: true
    validates :task_assessment, presence: true
    validates :task_behavior, presence: true
    validates :task_behavior_extra, presence: true
    validates :task_feedback, presence: true
    #validates :task_duedate, presence: true
    
    belongs_to :course 
    belongs_to :room 
    has_many :taskresults
    has_many :feedbacks
end
