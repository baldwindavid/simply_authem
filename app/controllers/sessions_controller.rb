class SessionsController < ApplicationController
  
  skip_before_filter SimplyAuthem.config['authentication_before_filter_method_name'].intern
  
  def new
  end
  
  def create
    session[:authentication_field] = params[:authentication_field]
    session[:password] = params[:password]
    redirect_back_or_default('/')
  end
  
  def destroy
    reset_session
    flash[:notice] = "You have been logged out"
    redirect_back_or_default('/')
  end
end
