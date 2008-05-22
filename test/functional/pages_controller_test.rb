require File.dirname(__FILE__) + '/../test_helper'

class PagesControllerTest < ActionController::TestCase
  
  fixtures :pages
  
  def test_should_redirect_to_new_session_when_requesting_admin_actions
    get :new
    assert_login_redirect

    get :edit
    assert_login_redirect
    
    post :create
    assert_login_redirect
    
    put :update
    assert_login_redirect
    
    delete :destroy
    assert_login_redirect
    
    get :title, { :id => 'some-personal-data' }
    assert_login_redirect
  end
  
  def test_index_should_find_all_pages_when_authenticated
    get :index, {}, { :admin => true }
    assert_response :success
    assert_equal 4, assigns(:pages).size
  end
  
  def test_index_should_find_only_public_pages_when_not_authenticated
    get :index
    assert_response :success
    assert_equal 3, assigns(:pages).size
  end
  
  def test_title_should_redirect_to_pages_path_and_display_message_if_title_not_found
    get :title, :id => 'not-present-page'
    
    assert_redirected_to pages_path
    assert_equal "Page with title 'not-present-page' not found", flash[:error]
  end

  def test_title_should_show_public_page_if_title_found_and_not_authenticated
    get :title, :id => 'correct-page'

    assert_template 'title'
    assert_response :success
    assert_equal 'Correct Page', assigns(:page_title)
    assert_equal '<p>Hello world</p>', assigns(:page_body)
    assert_equal pages(:correct), assigns(:page)
  end
  
  def test_title_should_show_public_page_if_title_found_and_authenticated
    get :title, { :id => 'correct-page' }, { :admin => true }

    assert_template 'title'
    assert_response :success
    assert_equal 'Correct Page', assigns(:page_title)
    assert_equal '<p>Hello world</p>', assigns(:page_body)
    assert_equal pages(:correct), assigns(:page)
  end
  
  def test_title_should_show_private_page_if_title_found_and_authenticated
    get :title, { :id => 'some-personal-data' }, { :admin => true }

    assert_template 'title'
    assert_response :success
    assert_equal 'Some Personal Data', assigns(:page_title)
    assert_equal '<p>My credit card number is 123456</p>', assigns(:page_body)
    assert_equal pages(:private), assigns(:page)
  end
  
  def test_show_should_redirect_to_title_and_keep_flash
    get :show, { :id => pages(:correct).id }, { }, { :par1 => 'val1', :par2 => 'val2'}

    assert_redirected_to :action => 'title', :id => 'correct-page'

    flash.sweep # to set the flash as it is available to the next action
    assert_not_nil flash[:par1], 'par1'
    assert_not_nil flash[:par2], 'par2'
  end
  
  def test_new_should_get_new
    get :new, {}, { :admin => true }

    assert_template 'edit'
    assert_response :success
    assert assigns(:page).new_record?
  end

  def test_edit_should_get_edit
    get :edit, { :id => pages(:correct).id }, { :admin => true }

    assert_template 'edit'
    assert_response :success
    assert_equal pages(:correct), assigns(:page)
  end

  def test_should_create_page
    pages(:correct).destroy
    assert_difference('Page.count') do
      #post :create, { :page => pages(:correct).attributes(:except => [ :id, :updated_at, :created_at ]) }, { :admin => true }
      post :create, { :page => pages(:correct).attributes.except(:id, :updated_at, :created_at ) }, { :admin => true }
    end
    assert_redirected_to page_path(assigns(:page))
    assert_equal 'Page was successfully created.', flash[:notice]
  end

  def test_create_should_redirect_to_edit_page_in_case_of_save_error
    #post :create, { :page => pages(:invalid).attributes(:except => [ :id, :updated_at, :created_at ]) }, { :admin => true }
    post :create, { :page => pages(:invalid).attributes.except( :id, :updated_at, :created_at ) }, { :admin => true }
    
    assert_template 'edit'
    assert !assigns(:page).valid?
  end

  def test_should_update_page
    put :update, { :id => pages(:correct).id, :page => { } }, { :admin => true }
    assert_redirected_to page_path(assigns(:page))
    assert_equal 'Page was successfully updated.', flash[:notice]
  end

  def test_should_render_edit_template_in_case_of_update_fail
    put :update, { :id => pages(:invalid).id, :page => { } }, { :admin => true }
    assert_template 'edit'
    assert !assigns(:page).valid?
  end

  def test_should_destroy_page
    assert_difference('Page.count', -1) do
      delete :destroy, { :id => pages(:correct).id }, { :admin => true }
    end

    assert_redirected_to pages_path
  end
end
