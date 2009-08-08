module SimplyAuthemSystem
  
  protected
  
  def login_required
    authorized? || access_denied
  end
  
  def access_denied
    store_location
    redirect_to :controller => '/sessions', :action => 'new'
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end  
  
  def redirect_back_or_default(default)
    session[:return_to] ? redirect_to(session[:return_to]) : redirect_to(default)
    session[:return_to] = nil
  end  
  
  def self.included(base)
    base.send :helper_method, :logged_in?, :current_user
  end
  
  def logged_in?
    !!current_user
  end
  
  def authorized?
    logged_in?
  end

  def current_user
    SimplyAuthemUser.authenticate(session[:authentication_field], session[:password])
  end
  
end