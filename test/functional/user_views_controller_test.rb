require File.dirname(__FILE__) + '/../test_helper'

class UserViewsControllerTest < ActionController::TestCase
  def test_blog_uri
    assert_get_uri "sakinijino.blogbus.com"
    assert_get_uri "www.google.com/search?hl=en&q=ruby+url+regexp"
    assert_get_uri "www.google.com/reader/view/#stream/feed%2Fhttp%3A%2F%2Fcn.engadget.com%2Frss.xml"
    assert_get_uri "www.zhuaxia.com/index.php#showCh(18570,10,0,-1,1,1)"
  end
  
  private
    def assert_get_uri(uri)
      u = users(:saki)
      u.blog = uri
      u.save
      get :show, :id => u.id
      assert_select "a[href=#{u.full_blog_uri}]"
    end
end
