class Taskresult < ApplicationRecord
    scope :taskresult_by_room ,-> (cid,rid){
            joins(:task).select("*,tasks.id tid,taskresults.id trid")
            .where(:tasks => {:room_id => rid,:course_id => cid})
    }
    belongs_to :task 
    belongs_to :user 
end
