# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '76a31a8856fe6c479a76e63061162a3b'
  
  helper_method :admin?, :guest?
  
  protected
  
  def authorize
    unless admin?
      # Can cause strange behaviours in case of request.request_method other than :get
      flash[:original_uri] = request.request_uri 
      flash[:notice] = 'Password needed.'
      redirect_to new_session_path
    end
  end
  
  def admin?
    session[:admin] == true
  end
  
  def guest?
    !admin?
  end
  
  def login(password)
    session[:admin] = (password == ADMIN_PASSWORD)
  end
  
  def logout
    session[:admin] = false
    true
  end

end
