require File.dirname(__FILE__) + '/../test_helper'

class FileResourceTest < ActiveSupport::TestCase
  def test_find_should_retrieve_all_file_resources_ordered_by_name
    FileResource.new('file1.txt').write('content of file 1')
    FileResource.new('another-file.txt').write('content of another file')
    FileResource.new('name').write('some content')

    files = FileResource.find(:all)
    assert_equal ['another-file.txt', 'file1.txt', 'name'].sort, files.collect { |file_resource| file_resource.name }
  end
  
  def test_write_should_create_file
    FileResource.new('name').write('some content')
    
    full_path = File.join(FileResource::BASE_PATH, 'name')
    assert File.exist?(full_path), 'file not created'
    assert_equal 'some content', IO.read(full_path), "file content doesn't mach"
  end
  
  def test_write_should_throw_exception_if_file_exists
    FileResource.new('name').write('some content')
    begin
      FileResource.new('name').write('some content')
    rescue
      assert_equal "FileResource name already exists", $!.message
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
