class SessionsController < ApplicationController
  
  skip_before_filter :login_required
  
  def new
  end
  
  def create
    session[:authentication_field] = params[:authentication_field]
    session[:password] = params[:password]
    flash[:notice] = "You have been authenticated"
    redirect_back_or_default('/')
  end
  
  def destroy
    reset_session
    flash[:notice] = "You have been logged out"
    redirect_back_or_default('/')
  end
end
