require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase

  def test_should_get_new
    flash_hash = ActionController::Flash::FlashHash.new
    flash_hash.now[:original_uri] = '/uri'
    flash_hash.now[:original_method] = :get
    flash_hash.now[:other] = 'value'

    get :new, {}, { :flash => flash_hash }
    
    assert_response :success
    assert_equal '/uri', flash[:original_uri]
    assert_equal :get, flash[:original_method]
    assert_nil flash[:other]
  end

  def test_crate_with_password_match
    flash_hash = ActionController::Flash::FlashHash.new
    flash_hash.now[:original_uri] = '/uri'

    post :create, { :password => ADMIN_PASSWORD }, { :flash => flash_hash }
    
    assert_equal 'Succesfully logged in.', flash[:notice]
    assert_redirected_to '/uri'
  end
  
  def test_crate_with_wrong_password
    flash_hash = ActionController::Flash::FlashHash.new
    flash_hash.now[:original_uri] = '/url'

    post :create, { :password => 'wrong' }, { :flash => flash_hash }

    assert_equal 'Wrong password.', flash[:error]
    assert_equal '/url', flash[:original_uri]
    assert_redirected_to new_session_path
  end
  
  def test_should_destroy_session
    delete :destroy, {}, { :admin => true }
    assert session[:admin] != true
    assert_equal 'Succesfully logged out.', flash[:notice]
    assert_redirected_to ''
  end
end
