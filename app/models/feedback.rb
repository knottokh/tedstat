class Feedback < ApplicationRecord
    scope :feedback_by_user ,-> (tsid,uid){
            where(:user_id => uid,:taskresult_id => tsid)
    }
    validates :feed_text, presence: true
    
    belongs_to :user 
    belongs_to :taskresult 
    belongs_to :task 
end
