# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  #before_action :configure_sign_up_params, only: [:create]
  #before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end
  
  # GET /resource/sign_up
  def newteacher
    build_resource
    yield resource if block_given?
    flash[:istteacher] = true
    redirect_to new_user_registration_path(resource)
    #respond_with resource, location: new_user_registration_path(resource)
  end

  # POST /resource
  def create
    flash[:istteacher] = params[:istteacher]
    super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end
  
  # GET /resource/sign_up
  def editteacher
    flash[:istteacher] = true
    redirect_to edit_user_registration_path
  end

  # PUT /resource
  def update
    flash[:istteacher] = params[:istteacher]
    super
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  #def sign_up_params
  #  params.require(resource_name).permit([:school_id,:password,:password_confirmation,
  #                      :prefix,:name,:surname,:student_code,:role,:email])
  #end
  #def user_params
  #   params.require(resource_name).permit([:school_id,:password,:password_confirmation,
  #                      :prefix,:name,:surname,:student_code,:role,:email])
  #end
end
