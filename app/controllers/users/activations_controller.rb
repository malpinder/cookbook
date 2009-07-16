class Users::ActivationsController < ApplicationController

  def new
    
  end
  def create
    @user = User.find_by_username(params[:user][:username])

    if @user.nil?
      flash[:error] = 'That user doesn\t appear to exist. Please try registering again.'
      redirect_to new_user_path and return
    end

    UserMailer.deliver_registration_confirmation(@user)
    flash[:notice] = 'Another email has been set to the address you specified; please follow the instructions in it to be able to use your account.'
    redirect_to new_session_path
  end
  
  def update
    @user = User.find(params[:user_id])
    if @user.activated == true
      flash[:notice] = 'That account has already been activated.'
      redirect_to new_session_path and return
    end

    if @user.activation_code != params[:code]
      flash[:warning] = 'The code you supplied is incorrect.'
      redirect_to welcome_path and return
    end

    @user.activated = true
    @user.save
    flash[:notice] = 'Your account has now been activated. Please log in to continue.'
    redirect_to new_session_path
  end
end
