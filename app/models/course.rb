class Course < ApplicationRecord
    
    validates :couse_code, presence: true
    validates :couse_name, presence: true
    validates :couse_year, presence: true,length: {minimum: 4, maximum: 4}, format: { with: /\A[+-]?\d+?(_?\d+)*(\.\d+e?\d*)?\Z/, message: "accept Number only." }
    #validates :couse_detail, presence: true
    

    
    belongs_to :user  
    has_many :rooms
    has_many :scourses
    has_many :tasks
end
