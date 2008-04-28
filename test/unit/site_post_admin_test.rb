require File.dirname(__FILE__) + '/../test_helper'

class SitePostAdminTest < ActiveSupport::TestCase
  def test_is_an_admin
    assert !SitePostAdmin.is_an_admin?(users(:saki))
    assert SitePostAdmin.is_an_admin?(users(:mike2).id)
  end
end
