require File.dirname(__FILE__) + '/../test_helper'

class PageTest < ActiveSupport::TestCase
  
  fixtures :pages
  
  def test_correctness_of_correct_pages
    assert pages(:correct).save
    assert pages(:another_correct).save
    assert !pages(:invalid).save
  end
  
  def test_presence_of_url_title
    page = pages(:correct)
    page.url_title = nil
    assert !page.save
    page.url_title = ''
    assert !page.save
  end
  
  def test_presence_of_text_body
    page = pages(:correct)
    page.text_body = nil
    assert !page.save
    page.text_body = ''
    assert !page.save
  end
  
  def test_uniqueness_of_url_title
    page = pages(:another_correct)
    page.url_title = pages(:correct).url_title
    assert !page.save
  end
  
  def test_url_title_format
    page = pages(:another_correct)
    page.url_title = 'correct-url-title-123'
    assert page.save
    page.url_title = 'UPPERCASE-NOT-ALLOWED'
    assert !page.save
    page.url_title = 'spaces between not allowed'
    assert !page.save
    page.url_title = ' spaces-before-or-after-not-allowed  '
    assert !page.save
    page.url_title = '!"£$%&/()'
    assert !page.save
    page.url_title = "newline\nnot-allowed"
    assert !page.save
  end

#  def test_html_body
#    page = Page.new(:text_body => 'Hi')
#    blue_cloth = mock()
#    BlueCloth.expects(:new).with(page.text_body).returns(blue_cloth)
#    blue_cloth.expects(:to_html).returns('html')
#    
#    assert_equal 'html', page.html_body('')
#  end
  
  def test_html_body
    page = Page.new(:text_body => '**Hello [[page-link]] World!**')
    assert_equal "<p><strong>Hello <a href=\"http://link/page-link\">Page Link</a> World!</strong></p>", page.html_body{ |url_title| 'http://link/' + url_title }
  end
  
  def test_bluecloth_bugs
    assert_equal '<p><em>*Hi</em>*</p>', BlueCloth.new('**Hi**').to_html # expected '<p><strong>Hi</strong></p>'
  end
  
  def test_title
    Page.expects(:titleize_url_title).with('url-title').returns('Url Title')
    assert_equal 'Url Title', Page.new(:url_title => 'url-title').title
  end
  
  def test_titleize_url_title
    assert_equal 'Many Words And A Number 123', Page.titleize_url_title('many-words-and-a-number-123')
  end
  
  def test_text_body_with_page_links
    assert_equal "Hi <a href=\"http://link/home-page\">Home Page</a>", Page.new(:text_body => 'Hi [[home-page]]').text_body_with_page_links{ |url_title| 'http://link/' + url_title }
  end
  
  def test_private
    page = Page.new
    page.public=true
    assert !page.private?
    page.public=false
    assert page.private?
  end
  
  def test_update_attributes_with_versioning
    page = pages(:correct)
    version_count = page.page_versions.size
    page.update_attributes_with_versioning(:public => !page.public)
    assert_equal version_count, page.page_versions.size, 'should not add a version when changing non versioned fields'

    original_updated_at = page.updated_at
    original_text_body = page.text_body
    changed_text_body = page.text_body + ' changed'
    page.update_attributes_with_versioning(:text_body => changed_text_body)
    assert page.updated_at > original_updated_at, 'should change updated_at field'
    assert_equal changed_text_body, page.text_body, 'should update text_body field'
    assert_equal version_count + 1, page.page_versions.size, 'should create a new page version'
    
    version = page.page_versions.find(:first, :order => 'version_at DESC')
    assert_equal original_updated_at.to_s, version.version_at.to_s, "page version should have version_at like page's updated_at before saving"
    assert_equal original_text_body, version.text_body, "page verison should have text_body field like page's text_body field before updating"
    
  end
end
