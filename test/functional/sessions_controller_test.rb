require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase

  def test_new_should_keep_original_uri_and_render_new_template
    get :new, {}, {}, { :original_uri => '/uri', :other => 'value' }
    
    assert_response :success
    assert_template 'new'
    
    flash.sweep
    assert_equal '/uri', flash[:original_uri]
    assert_nil flash[:other]
  end

  def test_create_should_redirect_to_original_uri_if_password_match_and_original_uri_found
    post :create, { :password => ADMIN_PASSWORD }, {}, { :original_uri => '/uri' }
    
    assert_equal 'Succesfully logged in.', flash[:notice]
    assert_redirected_to '/uri'
  end
  
  def test_create_should_redirect_to_homepage_uri_if_password_match_and_original_uri_not_found
    post :create, { :password => ADMIN_PASSWORD }
    
    assert_equal 'Succesfully logged in.', flash[:notice]
    assert_redirected_to ''
  end
  
  def test_create_should_redirect_to_new_session_and_keep_original_uri_if_password_wrong
    post :create, { :password => 'wrong' }, {}, { :original_uri => '/url' }

    assert_equal 'Wrong password.', flash[:error]
    assert_equal '/url', flash[:original_uri]
    assert_redirected_to new_session_path
  end
  
  def test_destroy_should_logout_and_redirect_to_homepage
    delete :destroy, {}, { :admin => true }
    assert session[:admin] != true
    assert_equal 'Succesfully logged out.', flash[:notice]
    assert_redirected_to ''
  end
end
