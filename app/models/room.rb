class Room < ApplicationRecord
    #attr_accessible :course_id,:room_name,:room_pin,:attribute_point,:ratio_score,:ratio_grade
    scope :room_findbypin ,-> (pin){
         joins(:course).select("*,rooms.id roomid,courses.id courseid").where(:room_pin => pin)
    }  
    
    validates :course_id, presence: true
    validates :room_name, presence: true
    validates :room_pin, presence: true, uniqueness: true
    #validates :point_attr, numericality: { greater_than_or_equal_to: 0 }
    #validates :ratio_score, presence: true
    #validates :ratio_grade, presence: true
    
    belongs_to :course 
    has_many :scourses
    has_many :tasks
    has_many :emotions
end
