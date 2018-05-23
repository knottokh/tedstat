class ScoursesController < ApplicationController
    
    def updatestudennumber
     # my score - taskresult
     scourseu = Scourse.find(params[:scourseid])
     scourseu.update({:studenno => params[:order]})
     issave  = scourseu.save
     
     respond_to do |format|  
            format.html
            format.json { 
              render :json => {
                :results =>  issave
            } 
          }
     end
  end
end
