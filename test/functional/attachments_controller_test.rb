require File.dirname(__FILE__) + '/../test_helper'

class AttachmentsControllerTest < ActionController::TestCase
  
  def setup
    Attachment.new('image.jpg').write('an image here')
    Attachment.new('document.pdf').write('a document here')
  end
  
  def teardown
    Attachment.delete_all
  end
  
  def test_should_redirect_to_new_session_when_requesting_admin_actions
    get :index
    assert_login_redirect

    get :new
    assert_login_redirect
    
    post :create
    assert_login_redirect
    
    delete :destroy
    assert_login_redirect
  end
  
  def test_index_should_load_all_attachments
    get :index, nil, { :admin => true }

    assert_response :success

    assert_not_nil assigns(:attachments)
    assert_equal 2, assigns(:attachments).length
  end

  def test_new_should_render_new_template
    get :new, nil, { :admin => true }

    assert_response :success
    assert_template 'new'
  end

  def test_create_should_create_attachment_and_redirect_to_attachment_path
    file = stub('stub_file', :original_filename => 'name', :read => 'content')

    post :create, { :file => file }, { :admin => true }

    assert_redirected_to attachments_path
    assert_equal 'Attachment successfully created.', flash[:notice]
    assert_not_nil Attachment.find('name')
  end

  def test_create_should_redirect_to_attachment_path_and_display_error_when_cant_create_attachment
    file = stub('stub_file', :original_filename => 'image.jpg', :read => 'content')

    post :create, { :file => file }, { :admin => true }

    assert_redirected_to attachments_path
    assert_equal 'Attachment image already exists', flash[:error]
  end
  
  def test_destroy_should_delete_attachment_and_redirect_to_attachments_path
    delete :destroy, { :id => 'image.jpg'}, { :admin => true }
    
    assert_redirected_to attachments_path
    assert_equal 'Attachment successfully delete.', flash[:notice]
    assert_equal 1, Attachment.find(:all).length
  end
end
