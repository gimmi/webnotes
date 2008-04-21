require File.dirname(__FILE__) + '/../test_helper'

class PagesControllerTest < ActionController::TestCase
  
  fixtures :pages
  
  # Tests on ApplicationController#authorize
  def test_authorize_will_redirect_to_new_session_and_save_uri
    get :new
    assert_equal 'Password needed.', flash[:notice]
    assert_not_nil flash[:original_uri]
    assert_redirected_to new_session_path
  end
  
  def test_authorize_will_do_nothing_when_admin
    get :new, {}, { :admin => true }
    assert_equal 0, flash.length
    assert_response :success
  end
  # ----------------------------------------
  
  def test_should_get_index
    pages = [pages(:one)]
    Page.expects(:find).with(:all, :order => 'url_title').returns(pages)
    get :index, {}
    assert_response :success
    assert_equal pages, assigns(:pages)
  end
  
  def test_title_should_show_page_if_title_found
    page = pages(:correct)
    Page.expects(:find_by_url_title).with('page-title').returns(page)
    page.expects(:title).returns('Title')
    page.expects(:html_body).yields('link').returns('Body')
    @controller.expects(:url_for).with(:action => 'title', :id => 'link', :only_path => true)

    get :title, :id => 'page-title'

    assert_template 'title'
    assert_response :success
    assert_equal 'Title', assigns(:page_title)
    assert_equal 'Body', assigns(:page_body)
    assert_equal page, assigns(:page)
  end
  
  def test_title_should_redirect_to_pages_path_and_display_message_if_title_not_found
    Page.expects(:find_by_url_title).with('page-title').returns(nil)
    @controller.expects(:pages_path).returns('/path')
    
    get :title, :id => 'page-title'
    
    assert_redirected_to '/path'
    assert_equal "Page with title 'page-title' not found", flash[:error]
  end

  def test_show_should_redirect_to_title
    page = mock
    Page.expects(:find).with('123').returns(page)
    page.expects(:url_title).returns('title')
    flash_hash = ActionController::Flash::FlashHash.new
    flash_hash.now[:par1] = 'val1'
    flash_hash.now[:par2] = 'val2'
    
    get :show, { :id => 123 }, { :flash => flash_hash }

    assert_redirected_to :action => 'title', :id => 'title'
    assert_not_nil flash[:par1]
    assert_not_nil flash[:par2]
  end
  
  def test_new_should_get_new
    @controller.expects(:authorize)

    get :new, {}

    assert_template 'edit'
    assert_response :success
  end

  def test_edit_should_get_edit
    @controller.expects(:authorize)

    get :edit, { :id => pages(:one).id }

    assert_response :success
  end

  def test_should_create_page
    @controller.expects(:authorize)
    pages(:correct).destroy
    assert_difference('Page.count') do
      post :create, { :page => pages(:correct).attributes(:except => [ :id, :updated_at, :created_at ]) }
    end
    assert_redirected_to page_path(assigns(:page))
    assert_equal 'Page was successfully created.', flash[:notice]
  end

  def test_create_should_redirect_to_edit_page_in_case_of_save_error
    @controller.expects(:authorize)
    post :create, { :page => pages(:invalid).attributes(:except => [ :id, :updated_at, :created_at ]) }
    assert_template 'edit'
  end

  def test_should_update_page
    @controller.expects(:authorize)
    put :update, { :id => pages(:correct).id, :page => { } }
    assert_redirected_to page_path(assigns(:page))
  end

  def test_should_render_edit_template_in_case_of_update_fail
    @controller.expects(:authorize)
    put :update, { :id => pages(:invalid).id, :page => { } }
    assert_template 'edit'
  end

  def test_should_destroy_page
    @controller.expects(:authorize)
    assert_difference('Page.count', -1) do
      delete :destroy, { :id => pages(:one).id }
    end

    assert_redirected_to pages_path
  end
end
