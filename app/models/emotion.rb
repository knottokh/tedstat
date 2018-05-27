class Emotion < ApplicationRecord
    scope :find_by_user_room_course_created ,-> (cid,rid,uid){
         where(:room_id => rid,:course_id => cid,:user_id => uid,:created_at => Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)    
    }
    scope :find_by_user_room_course ,-> (cid,rid,uid,dateform,dateto){
        where(:room_id => rid,:course_id => cid,:user_id => uid,:created_at => dateform..dateto)    
         #where(:room_id => rid,:course_id => cid,:user_id => uid)    
    }
    belongs_to :user 
    belongs_to :course 
    belongs_to :room 
end
