class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    unless @user.valid?
      render :action => :new
      return
    end

    @user.save
    UserMailer.deliver_registration_confirmation(@user)
    flash[:notice] = 'Thankyou for registering with cookbook. An email has been set to the address you specified; please follow the instructions in it to be able to use your account.'
    redirect_to new_session_path
  end

  def show
    @user = User.find(params[:id])
  end

  def ids_match?
    return true if session[:user_id].to_i == params[:id].to_i
    return false
  end

  def edit
    unless ids_match?
      flash[:warning] = 'You don\'t have permission to edit those details.'
      redirect_to user_path(:id => session[:user_id])
      return
    end

    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    unless @user.update_attributes(params[:user])
      flash[:error] = 'Update failed.'
      render :action => :edit
      return
    end

    flash[:notice] = 'Updated details succesfully.'
    redirect_to user_path
  end

end
