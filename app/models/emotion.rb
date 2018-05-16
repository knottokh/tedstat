class Emotion < ApplicationRecord
    
    belongs_to :user 
    belongs_to :course 
    belongs_to :room 
end
