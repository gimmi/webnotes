require File.dirname(__FILE__) + '/../test_helper'

class FileResourceTest < ActiveSupport::TestCase
  def test_find_should_retrieve_all_file_resources_ordered_by_name
    FileResource.create('file1.txt', 'content of file 1')
    FileResource.create('another-file.txt', 'content of another file')
    FileResource.create('name', 'some content')

    files = FileResource.find(:all)
    assert_equal ['another-file.txt', 'file1.txt', 'name'].sort, files.collect { |file_resource| file_resource.name }
  end
  
  def test_create_should_create_file
    FileResource.create('name', 'some content')
    
    full_path = File.join(FileResource::BASE_PATH, 'name')
    assert File.exist?(full_path), 'file not created'
    assert_equal 'some content', IO.read(full_path), "file content doesn't mach"
  end
  
  def test_delete_should_delete_file_if_file_exists
    FileResource.create('name', 'some content')
    FileResource.delete('name')

    full_path = File.join(FileResource::BASE_PATH, 'name')
    assert !File.exist?(full_path)
  end
  
  def test_delete_should_throw_exception_if_file_doesnt_exists
    begin
    FileResource.delete('name')
    rescue RuntimeError => err
      assert_equal "FileResource name doesn't exists", err.message
    else
      fluck
    end
  end
  
  def test_create_should_throw_exception_if_file_exists
    FileResource.create('name', 'some content')
    begin
      FileResource.create('name', 'some content')
    rescue RuntimeError => err
      assert_equal "FileResource name already exists", err.message
    else
      flunk
    end
  end
  
  def teardown
    Dir.foreach(FileResource::BASE_PATH) do |file_name|
      File.delete(File.join(FileResource::BASE_PATH, file_name)) unless file_name =~ /\A\./
    end
  end
end
