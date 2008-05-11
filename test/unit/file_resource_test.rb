require File.dirname(__FILE__) + '/../test_helper'

class FileResourceTest < ActiveSupport::TestCase
  def setup
    @name = 'name'
    @full_name = File.join(FileResource::BASE_PATH, @name)
  end
  
  def test_write_writes_content_to_file
    file = FileResource.new(@name)
    file.write('some content')
    
    assert File.exist?(@full_name), 'file not created'
    assert_equal 'some content', IO.read(@full_name), "file content doesn't mach"
    
    files = FileResource.find
    assert_equal 1, files.length, 'one file must be found'
    assert_equal @name, files[0].name, 'created file must be found'
  end
  
  def teardown
    File.delete(@full_name) if File.exists?(@full_name)
  end
end
