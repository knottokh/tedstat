class AdminController < ApplicationController
     #GET show approve
  def import
      # @anser1 = sum_all_teacher_by_school(1)#select_music_school(1,'(2,3,4)','IN')
      #@anser1 = Devise::Encryptors::Aes256.decrypt("$2a$11$YtzV.NT9eXIqnOi0iSCLmO5AqOgF8YKq7Pda5lZUdNjsO.NAkwFY2" , Devise.pepper)
  end
  def importpost
      tablecol = nil
      model = nil
      case params[:dbtable]
        when "School"
            model = School
            tablecol  = ["education_area","ministry_code","school_name","municipal_area","district","province","postcode","zone","students_count"]
      end
      if !tablecol.nil? && !model.nil?        
          importfile(model,tablecol,params[:file])
          flash[:importmsg] = ["Import Success"]
      else
          flash[:importmsg] = ["Can't Import"]
      end
      render action: :import
  end
end
