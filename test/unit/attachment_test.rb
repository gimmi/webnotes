require File.dirname(__FILE__) + '/../test_helper'

class AttachmentTest < ActiveSupport::TestCase
  def test_find_should_retrieve_all_file_resources_ordered_by_name
    Attachment.new('file1.txt').write('content of file 1')
    Attachment.new('another-file.txt').write('content of another file')
    Attachment.new('name').write('some content')

    files = Attachment.find(:all)
    assert_equal ['another-file', 'file1', 'name'].sort, files.collect { |attachment| attachment.name }
  end
  
  def test_find_should_find_resource_by_name
    Attachment.new('file1.txt').write('content of file 1')
    Attachment.new('another-file.txt').write('content of another file')
    attachment = Attachment.find('another-file')
    assert_equal 'another-file', attachment.name
    assert_nil Attachment.find('non-present-file')
  end
  
  def test_split_and_normalize_file_name
    assert_equal ['i-m-a12-js--', '.jpg'], Attachment.split_and_normalize_file_name('i m_a12?JS[].jpg')
    assert_equal ['image', ''], Attachment.split_and_normalize_file_name('image')
  end
  
  def test_delete_should_delete_file_if_file_exists
    attachment = Attachment.new('name.jpg')
    attachment.write('some content')
    attachment.delete

    assert !File.exist?(File.join(Attachment::BASE_PATH, 'name.jpg'))
  end
  
  def test_write_should_create_file
    attachment = Attachment.new('name.txt')
    attachment.write('some content')
    
    full_path = File.join(Attachment::BASE_PATH, 'name.txt')
    assert File.exist?(full_path)
    assert_equal 'some content', IO.read(full_path)
  end
  
  def test_write_should_throw_exception_if_file_exists
    Attachment.new('name.txt').write('some content')
    begin
      Attachment.new('name.jpg').write('some content')
    rescue RuntimeError => err
      assert_equal "Attachment name already exists", err.message
    else
      flunk
    end
  end

  def teardown
    Attachment.delete_all
  end
end
