class SessionsController < ApplicationController

  def new
    
  end

  def create
    @user = User.valid_user(params[:user])

    if @user.nil?
      flash[:error] = 'Incorrect details provided.'
      redirect_to new_session_path
      return
    end

    session[:user_id] = @user.id
    redirect_to user_path(@user)
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'You have been logged out.'
    redirect_to :back
  end

end
