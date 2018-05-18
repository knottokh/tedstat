class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :set_locale
  
  protect_from_forgery with: :exception
  
  def set_locale
    session[:locale] = "th"
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
  end
  
  def set_master_layout(val)
      @master_layout  = val
  end      
  def check_user_home!
    if !current_user.nil?
      if current_user.student? 
        #sign_out(current_user)
        redirect_to student_dashboard_path
      elsif current_user.teacher? 
          redirect_to teacher_dashboard_path
      end 
    end
  end
  def is_teacher!
    if !current_user.teacher? 
      #sign_out(current_user)
      redirect_to root_path ,notice: "You trying to access without permission role Teacher!"
    end 
  end
  def is_student!
    if !current_user.student? 
      #sign_out(current_user)
      redirect_to root_path ,notice: "You trying to access without permission role Student!"
    end 
  end
  def respond_modal_with(*args, &blk)
    options = args.extract_options!
    options[:responder] = ModalResponder
    respond_with *args, options, &blk
  end
  def respond_empty_with(*args, &blk)
    options = args.extract_options!
    options[:responder] = EmptyResponder
    respond_with *args, options, &blk
  end
end
