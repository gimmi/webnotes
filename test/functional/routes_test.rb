require File.dirname(__FILE__) + '/../test_helper'

require 'action_controller/routing'

class RoutesTest < Test::Unit::TestCase
  def test_homepage
    assert_routing '', :controller => 'pages', :action => 'index'
    assert_recognizes({ :controller => 'pages', :action => 'index' }, '')
  end
end
