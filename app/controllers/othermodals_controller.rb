class OthermodalsController < ApplicationController
  respond_to :html, :json
  def infostudent
    @stuuser = User.find(params[:uid])
    respond_modal_with @stuuser , location: managecourse_path
  end
end
