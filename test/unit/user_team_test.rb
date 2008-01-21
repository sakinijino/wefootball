require File.dirname(__FILE__) + '/../test_helper'

class UserTeamTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_through
    assert users(:saki).teams.length==2
    assert users(:saki).teams.admin.length==2
    assert users(:quentin).teams.length==1
    assert users(:quentin).teams.admin.length==1
    assert users(:aaron).teams.length==1
    assert users(:aaron).teams.admin.length==0
    
    assert teams(:inter).users.length==2
    assert teams(:milan).users.length==2
    assert teams(:inter).users.admin.length==2
    assert teams(:milan).users.admin.length==1
  end
end
