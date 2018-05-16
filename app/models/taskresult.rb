class Taskresult < ApplicationRecord
    scope :taskresult_by_room ,-> (cid,rid){
            joins(:task).select("*,tasks.id tid,taskresults.id trid")
            .where(:tasks => {:room_id => rid,:course_id => cid})
    }
    scope :taskresult_by_room_user ,-> (cid,rid,uid){
            joins(:task).select("*,tasks.id tid,taskresults.id trid")
            .where(:tasks => {:room_id => rid,:course_id => cid} , :taskresults => {:user_id => uid})
    }
    scope :taskresult_by_id ,-> (tid){
            joins(:task).select("*,tasks.id tid,taskresults.id trid").find(tid.to_i)
    }
    belongs_to :task 
    belongs_to :user 
    has_many :feedbacks
end
