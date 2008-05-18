require File.dirname(__FILE__) + '/../test_helper'

class AttachmentTest < ActiveSupport::TestCase
  def test_find_should_retrieve_all_file_resources_ordered_by_name
    Attachment.create('file1.txt', 'content of file 1')
    Attachment.create('another-file.txt', 'content of another file')
    Attachment.create('name', 'some content')

    files = Attachment.find(:all)
    assert_equal ['another-file.txt', 'file1.txt', 'name'].sort, files.collect { |attachment| attachment.name }
  end
  
  def test_create_should_create_file
    Attachment.create('name', 'some content')
    
    full_path = File.join(Attachment::BASE_PATH, 'name')
    assert File.exist?(full_path), 'file not created'
    assert_equal 'some content', IO.read(full_path), "file content doesn't mach"
  end
  
  def test_delete_should_delete_file_if_file_exists
    Attachment.create('name', 'some content')
    Attachment.delete('name')

    full_path = File.join(Attachment::BASE_PATH, 'name')
    assert !File.exist?(full_path)
  end
  
  def test_delete_should_throw_exception_if_file_doesnt_exists
    begin
    Attachment.delete('name')
    rescue RuntimeError => err
      assert_equal "Attachment name doesn't exists", err.message
    else
      fluck
    end
  end
  
  def test_create_should_throw_exception_if_file_exists
    Attachment.create('name', 'some content')
    begin
      Attachment.create('name', 'some content')
    rescue RuntimeError => err
      assert_equal "Attachment name already exists", err.message
    else
      flunk
    end
  end
  
  def teardown
    Attachment.delete(:all)
  end
end
