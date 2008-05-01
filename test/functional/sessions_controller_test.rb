require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase

  def test_new_should_keep_original_uri_and_rtender_new_template
    flash_hash = ActionController::Flash::FlashHash.new
    flash_hash.now[:original_uri] = '/uri'
    flash_hash.now[:other] = 'value'

    get :new, {}, { :flash => flash_hash }
    
    assert_response :success
    assert_template 'new'
    assert_equal '/uri', flash[:original_uri]
    assert_nil flash[:other]
  end

  def test_create_should_redirect_to_original_uri_if_password_match
    flash_hash = ActionController::Flash::FlashHash.new
    flash_hash.now[:original_uri] = '/uri'

    post :create, { :password => ADMIN_PASSWORD }, { :flash => flash_hash }
    
    assert_equal 'Succesfully logged in.', flash[:notice]
    assert_redirected_to '/uri'
  end
  
  def test_create_should_redirect_to_new_session_and_keep_original_uri_if_password_wrong
    flash_hash = ActionController::Flash::FlashHash.new
    flash_hash.now[:original_uri] = '/url'

    post :create, { :password => 'wrong' }, { :flash => flash_hash }

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
