require File.dirname(__FILE__) + '/../test_helper'

class TeamTest < ActiveSupport::TestCase
  def test_image_path
    assert_equal "/images/teams/t00000001.jpg", teams(:inter).image
    assert_equal "/images/default_team.jpg", teams(:milan).image
  end
  
  def test_validation
    assert_no_difference 'Team.count' do
      u = create_team({
          :name => 's'*300
        })
      assert u.errors.on(:name)
    end
    
    assert_no_difference 'Team.count' do
      u = create_team({
          :shortname => 's'*300
        })
      assert u.errors.on(:shortname)
    end
    
    assert_no_difference 'Team.count' do
      u = create_team({
          :summary => 's'*1000
        })

      assert u.errors.on(:summary)
    end
    
    assert_no_difference 'Team.count' do
      u = create_team({
          :style=>'s'*80
        })
      assert u.errors.on(:style)
    end
  end
protected
  def create_team(options = {})
    Team.create({ :name => 'AC Milan', 
        :shortname => 'AC', 
        :summary => 'Italy',
        :found_time => Date.new(2008,1,21),
        :style => 'Defence'
      }.merge(options))
  end
end