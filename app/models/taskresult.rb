class Taskresult < ApplicationRecord
    scope :taskresult_by_room ,-> (cid,rid){
            joins(:task).select("*,tasks.id tid,taskresults.id trid")
            .where(:tasks => {:room_id => rid,:course_id => cid})
    }
    scope :taskresult_by_taskid ,-> (taskid){
            where(:task_id => taskid)
    }
    scope :taskresult_by_room_user ,-> (cid,rid,uid){
            joins(:task).select("*,tasks.id tid,taskresults.id trid")
            .where(:tasks => {:room_id => rid,:course_id => cid} , :taskresults => {:user_id => uid})
    }
    scope :taskresult_by_id ,-> (tid){
            joins(:task).select("*,tasks.id tid,taskresults.id trid").find(tid.to_i)
    }
    scope :taskresult_scoreonly ,-> (tid){
            joins(:task).select("*,tasks.id tid,taskresults.id trid")
            .where("taskresults.task_id = #{tid} AND (tasks.task_behavior = 'คะแนน (scoring)' OR tasks.task_behavior = 'rating scale') AND taskresults.score IS NOT NULL")
            #.where(:tasks => {:room_id => rid,:course_id => cid} , :taskresults => {:task_id => tid})
    }
    scope :taskresult_notnull ,-> (cid,rid,uid){
            joins(:task).select("*,tasks.id tid,taskresults.id trid")
            .where("tasks.room_id = #{rid} AND tasks.course_id = #{cid} AND taskresults.score IS NOT NULL AND taskresults.user_id = #{uid}")
            #.where(:tasks => {:room_id => rid,:course_id => cid} , :taskresults => {:task_id => tid})
    }
    scope :taskresult_scoreonly_user ,-> (cid,rid,uid){
            joins(:task).select("*,tasks.id tid,taskresults.id trid")
            .where("tasks.room_id = #{rid} AND tasks.course_id = #{cid} AND (tasks.task_behavior = 'คะแนน (scoring)' OR tasks.task_behavior = 'rating scale') AND taskresults.score IS NOT NULL AND taskresults.user_id = #{uid}")
            .order("tasks.id asc")
            #.where(:tasks => {:room_id => rid,:course_id => cid} , :taskresults => {:task_id => tid})
    }
    scope :taskresult_by_task_user ,-> (tid,uid){
            joins(:task).select("*").where(:taskresults => {:task_id => tid , :user_id => uid})
    }
    belongs_to :task 
    belongs_to :user 
    has_many :feedbacks
end
