require File.dirname(__FILE__) + '/../test_helper'

require 'action_controller/routing'

class RoutesTest < Test::Unit::TestCase
  def test_homepage
    assert_routing '', :controller => 'pages', :action => 'index'
    assert_recognizes({ :controller => 'pages', :action => 'index' }, '')
  end
  
  def test_attachments
    assert_recognizes({ :controller => 'attachments', :action => 'show', :id => 'file' }, '/attachments/file')
    assert_recognizes({ :controller => 'attachments', :action => 'show', :id => 'file with space' }, '/attachments/file with space')
    assert_recognizes({ :controller => 'attachments', :action => 'new' }, '/attachments/new')
  end
end
