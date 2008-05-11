require File.dirname(__FILE__) + '/../test_helper'

class FileResourceTest < ActiveSupport::TestCase
  def setup
  end
  
  def test_write_writes_content_to_file
    FileResource.new('file1.txt').write('content of file 1')
    FileResource.new('another-file.txt').write('content of another file')
    FileResource.new('name').write('some content')
    
    full_path = File.join(FileResource::BASE_PATH, 'name')
    assert File.exist?(full_path), 'file not created'
    assert_equal 'some content', IO.read(full_path), "file content doesn't mach"
    
    files = FileResource.find(:all)
    assert_equal ['another-file.txt', 'file1.txt', 'name'], files.collect { |file_resource| file_resource.name }
  end
  
  def teardown
    Dir.foreach(FileResource::BASE_PATH) do |file_name|
      File.delete(File.join(FileResource::BASE_PATH, file_name)) unless file_name =~ /\A\./
    end
  end
end
