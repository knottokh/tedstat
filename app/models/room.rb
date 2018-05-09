class Room < ApplicationRecord
    scope :room_findbypin ,-> (pin){
         joins(:course).select("*,rooms.id roomid,courses.id courseid").where(:room_pin => pin)
     }  
    
    validates :course_id, presence: true
    validates :room_name, presence: true
    validates :room_pin, presence: true, uniqueness: true
    
    belongs_to :course 
    has_many :scourses
    has_many :tasks
end
