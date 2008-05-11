require File.dirname(__FILE__) + '/../test_helper'

class FileResourcesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:file_resources)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_file_resource
    assert_difference('FileResource.count') do
      post :create, :file_resource => { }
    end

    assert_redirected_to file_resource_path(assigns(:file_resource))
  end

  def test_should_show_file_resource
    get :show, :id => file_resources(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => file_resources(:one).id
    assert_response :success
  end

  def test_should_update_file_resource
    put :update, :id => file_resources(:one).id, :file_resource => { }
    assert_redirected_to file_resource_path(assigns(:file_resource))
  end

  def test_should_destroy_file_resource
    assert_difference('FileResource.count', -1) do
      delete :destroy, :id => file_resources(:one).id
    end

    assert_redirected_to file_resources_path
  end
end
