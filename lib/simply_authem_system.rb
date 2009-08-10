module SimplyAuthemSystem
  
  protected
  
  # Authentication before_filter method name
  # default is login_required
  # can be changed in config/simply_authem.yml
  define_method SimplyAuthem.config['authentication_before_filter_method_name'] do
    authorized? || access_denied
  end
  
  # Current user method
  # default is current_user
  # can be changed in config/simply_authem.yml
  define_method SimplyAuthem.config['current_user_method_name'] do
    SimplyAuthemUser.authenticate(session[:authentication_field], session[:password])
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
    !!send(SimplyAuthem.config['current_user_method_name'])
  end
  
  def authorized?
    logged_in?
  end
  
end