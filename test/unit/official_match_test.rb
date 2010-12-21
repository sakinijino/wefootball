require File.dirname(__FILE__) + '/../test_helper'

class OfficialMatchTest < ActiveSupport::TestCase
  def test_end_time
    m = OfficialMatch.new
    st = Time.today.tomorrow
    et = st.since(60*105)
    m.start_time = st
    m.host_team = official_teams(:inter)
    m.host_team = official_teams(:milan)
    m.save!
    assert_equal et, m.end_time
  end
  
  def test_before_validation
    m = OfficialMatch.new
    st = Time.today.tomorrow
    m.start_time = st
    m.host_team = official_teams(:inter)
    m.host_team = official_teams(:milan)
    m.description = "description"*1000
    assert m.valid?
    assert_equal 3000, m.description.length
  end
  
  def test_time_check
    m = OfficialMatch.new
    m.start_time = Time.now.tomorrow
    m.host_team = official_teams(:inter)
    m.host_team = official_teams(:milan)
    m.save!
    assert !m.started?
    assert !m.finished?
    
    m = OfficialMatch.new
    m.start_time = Time.now.ago(1800)
    m.host_team = official_teams(:inter)
    m.host_team = official_teams(:milan)
    m.save!
    assert m.started?
    assert !m.finished?
    
    m = OfficialMatch.new
    m.start_time = 1.days.ago
    m.host_team = official_teams(:inter)
    m.host_team = official_teams(:milan)
    m.save!
    assert m.started?
    assert m.finished?
  end
  
  def test_pk
    m = OfficialMatch.new
    m.host_team_goal = 2
    m.guest_team_goal = 1
    assert !m.pk?
    m.host_team_pk_goal = 0
    m.guest_team_pk_goal = 0
    assert !m.pk?
    m.host_team_pk_goal = 6
    m.guest_team_pk_goal = 5
    assert m.pk?
    m.host_team_pk_goal = 3
    m.guest_team_pk_goal = 0
    assert m.pk?
    m.host_team_pk_goal = 0
    m.guest_team_pk_goal = 3
    assert m.pk?
    m.host_team_pk_goal = nil
    m.guest_team_pk_goal = nil
    assert !m.pk?
  end
  
  def test_user_destroy_dependency_nullify
    u = users(:saki)
    l  = u.official_matches.size
    assert_no_difference "OfficialMatch.count" do
    assert_difference "OfficialMatch.find(:all, :conditions=>['user_id is null']).length", l do
      u.destroy
    end
    end
  end

  def test_import_match
    m = {
      :finished => false,
      :host_name => 'Inter Milan',
      :guest_name => 'AC Milan',
      :host_goal => nil,
      :guest_goal => nil,
      :guest_team_type => 7,
      :start_time => DateTime.parse("2000-01-01 00:00:00 +08:00")
    }

    assert_no_difference "OfficialMatch.count" do
    assert_no_difference "OfficialTeam.count" do
      new_teams = [];
      new_match = [];
      update_match = [];
      OfficialMatch.import_match(m) do |nt, nm, um|
        new_teams << nt
        new_teams.flatten!
        new_match << nm
        new_match.flatten!
        update_match << um
        update_match.flatten!
      end

      assert_equal 0, new_teams.length, "no new team"
      assert_equal 0, new_match.length, "no new match"
      assert_equal 0, update_match.length, "no update match"
    
      match = OfficialMatch.find(1)
      assert_equal m[:host_name], match.host_team_name, "unchanged host name"
      assert_equal m[:guest_name], match.guest_team_name, "unchanged guest name"
      assert_equal m[:start_time], match.start_time, "unchanged start time"
      assert_equal m[:host_goal], match.host_team_goal, "unchanged host goal"
      assert_equal m[:guest_goal], match.guest_team_goal, "unchanged guest goal"
      assert_equal 7, match.host_team.category, "unchanged host category"
      assert_equal 7, match.guest_team.category, "unchanged guest category"
    end
    end

    m = {
      :finished => false,
      :host_name => 'Inter Milan',
      :guest_name => 'AC Milan',
      :host_goal => nil,
      :guest_goal => nil,
      :host_team_type => 2,
      :guest_team_type => 2,
      :start_time => DateTime.parse("2000-01-01 00:00:00 +08:00")
    }

    assert_no_difference "OfficialMatch.count" do
    assert_no_difference "OfficialTeam.count" do
      new_teams = [];
      new_match = [];
      update_match = [];
      OfficialMatch.import_match(m) do |nt, nm, um|
        new_teams << nt
        new_teams.flatten!
        new_match << nm
        new_match.flatten!
        update_match << um
        update_match.flatten!
      end

      assert_equal 0, new_teams.length, "no new team"
      assert_equal 0, new_match.length, "no new match"
      assert_equal 0, update_match.length, "no update match"
    
      match = OfficialMatch.find(1)
      assert_equal m[:host_name], match.host_team_name, "unchanged host name"
      assert_equal m[:guest_name], match.guest_team_name, "unchanged guest name"
      assert_equal m[:start_time], match.start_time, "unchanged start time"
      assert_equal m[:host_goal], match.host_team_goal, "unchanged host goal"
      assert_equal m[:guest_goal], match.guest_team_goal, "unchanged guest goal"
      assert_equal m[:host_team_type], match.host_team.category
      assert_equal m[:guest_team_type], match.guest_team.category
    end
    end

    m = {
      :finished => false,
      :host_name => 'Inter Milan',
      :guest_name => 'AC Milan',
      :host_goal => 9,
      :guest_goal => 3,
      :start_time => DateTime.parse("2000-01-01 00:00:00 +08:00")
    }

    assert_no_difference "OfficialMatch.count" do
    assert_no_difference "OfficialTeam.count" do
      new_teams = [];
      new_match = [];
      update_match = [];
      OfficialMatch.import_match(m) do |nt, nm, um|
        new_teams << nt
        new_teams.flatten!
        new_match << nm
        new_match.flatten!
        update_match << um
        update_match.flatten!
      end

      assert_equal 0, new_teams.length
      assert_equal 0, new_match.length
      assert_equal 1, update_match.length

      match = update_match[0]
      assert_equal m[:host_name], match.host_team_name
      assert_equal m[:guest_name], match.guest_team_name
      assert_equal m[:start_time], match.start_time
      assert_equal m[:host_goal], match.host_team_goal
      assert_equal m[:guest_goal], match.guest_team_goal
    
      match = OfficialMatch.find(1)
      assert_equal m[:host_name], match.host_team_name
      assert_equal m[:guest_name], match.guest_team_name
      assert_equal m[:start_time], match.start_time
      assert_equal m[:host_goal], match.host_team_goal
      assert_equal m[:guest_goal], match.guest_team_goal
    end
    end

    m = {
      :finished => false,
      :host_name => 'Inter Milan',
      :guest_name => 'AC Milan',
      :host_goal => 9,
      :guest_goal => 3,
      :start_time => DateTime.parse("2010-01-01 00:00:00 +08:00")
    }

    assert_difference "OfficialMatch.count", 1 do
    assert_no_difference "OfficialTeam.count" do
      new_teams = [];
      new_match = [];
      update_match = [];
      OfficialMatch.import_match(m) do |nt, nm, um|
        new_teams << nt
        new_teams.flatten!
        new_match << nm
        new_match.flatten!
        update_match << um
        update_match.flatten!
      end

      assert_equal 0, new_teams.length
      assert_equal 1, new_match.length
      assert_equal 0, update_match.length

      match = new_match[0]
      assert_equal m[:host_name], match.host_team_name
      assert_equal m[:guest_name], match.guest_team_name
      assert_equal m[:start_time], match.start_time
      assert_equal m[:host_goal], match.host_team_goal
      assert_equal m[:guest_goal], match.guest_team_goal
    end
    end

    m = {
      :finished => false,
      :host_name => 'Inter Milan',
      :guest_name => 'Juv',
      :host_goal => 9,
      :guest_goal => 3,
      :host_team_type => 2,
      :start_time => DateTime.parse("2010-01-01 00:00:00 +08:00")
    }

    assert_difference "OfficialMatch.count", 1 do
    assert_difference "OfficialTeam.count", 1 do
      new_teams = [];
      new_match = [];
      update_match = [];
      OfficialMatch.import_match(m) do |nt, nm, um|
        new_teams << nt
        new_teams.flatten!
        new_match << nm
        new_match.flatten!
        update_match << um
        update_match.flatten!
      end

      assert_equal 1, new_teams.length
      assert_equal 1, new_match.length
      assert_equal 0, update_match.length

      t1 = new_teams[0]
      assert_equal m[:guest_name], t1.name

      match = new_match[0]
      assert_equal m[:host_name], match.host_team_name
      assert_equal m[:guest_name], match.guest_team_name
      assert_equal m[:start_time], match.start_time
      assert_equal m[:host_goal], match.host_team_goal
      assert_equal m[:guest_goal], match.guest_team_goal
      assert_equal m[:host_team_type], match.host_team.category
      assert_equal 7, match.guest_team.category
    end
    end

    m = {
      :finished => false,
      :host_name => 'Roma',
      :guest_name => 'Lazio',
      :host_goal => 9,
      :guest_goal => 3,
      :host_team_type => 2,
      :guest_team_type => 2,
      :start_time => DateTime.parse("2010-01-01 00:00:00 +08:00")
    }

    assert_difference "OfficialMatch.count", 1 do
    assert_difference "OfficialTeam.count", 2 do
      new_teams = [];
      new_match = [];
      update_match = [];
      OfficialMatch.import_match(m) do |nt, nm, um|
        new_teams << nt
        new_teams.flatten!
        new_match << nm
        new_match.flatten!
        update_match << um
        update_match.flatten!
      end

      assert_equal 2, new_teams.length
      assert_equal 1, new_match.length
      assert_equal 0, update_match.length

      t1= new_teams[0]
      assert_equal m[:host_name], t1.name
      t2 = new_teams[1]
      assert_equal m[:guest_name], t2.name

      match = new_match[0]
      assert_equal m[:host_name], match.host_team_name
      assert_equal m[:guest_name], match.guest_team_name
      assert_equal m[:start_time], match.start_time
      assert_equal m[:host_goal], match.host_team_goal
      assert_equal m[:guest_goal], match.guest_team_goal
      assert_equal m[:host_team_type], match.host_team.category
      assert_equal m[:guest_team_type], match.guest_team.category
    end
    end
  end

  def test_import_match_not_exact_time
    m = {
      :finished => false,
      :host_name => 'Inter Milan',
      :guest_name => 'AC Milan',
      :host_goal => nil,
      :guest_goal => nil,
      :host_team_type => 2,
      :guest_team_type => 2,
      :start_time => OfficialMatch.find(1).start_time
    }

    assert_no_difference "OfficialMatch.count" do
    assert_no_difference "OfficialTeam.count" do
      new_teams = [];
      new_match = [];
      update_match = [];
      OfficialMatch.import_match(m) do |nt, nm, um|
        new_teams << nt
        new_teams.flatten!
        new_match << nm
        new_match.flatten!
        update_match << um
        update_match.flatten!
      end

      assert_equal 0, new_teams.length, "no new team"
      assert_equal 0, new_match.length, "no new match"
      assert_equal 0, update_match.length, "no update match"
    
      match = OfficialMatch.find(1)
      assert_equal m[:host_name], match.host_team_name, "unchanged host name"
      assert_equal m[:guest_name], match.guest_team_name, "unchanged guest name"
      assert_equal m[:start_time], match.start_time, "unchanged start time"
      assert_equal m[:host_goal], match.host_team_goal, "unchanged host goal"
      assert_equal m[:guest_goal], match.guest_team_goal, "unchanged guest goal"
      assert_equal m[:host_team_type], match.host_team.category
      assert_equal m[:guest_team_type], match.guest_team.category
    end
    end

    m = {
      :finished => false,
      :host_name => 'Inter Milan',
      :guest_name => 'AC Milan',
      :host_goal => 2,
      :guest_goal => 2,
      :start_time => OfficialMatch.find(1).start_time + 2.hours 
    }

    assert_no_difference "OfficialMatch.count" do
    assert_no_difference "OfficialTeam.count" do
      new_teams = [];
      new_match = [];
      update_match = [];
      OfficialMatch.import_match(m) do |nt, nm, um|
        new_teams << nt
        new_teams.flatten!
        new_match << nm
        new_match.flatten!
        update_match << um
        update_match.flatten!
      end

      assert_equal 0, new_teams.length
      assert_equal 0, new_match.length
      assert_equal 1, update_match.length, "update start time add 2 hours"

      match = update_match[0]
      assert_equal m[:host_name], match.host_team_name
      assert_equal m[:guest_name], match.guest_team_name
      assert_equal m[:start_time], match.start_time
      assert_equal m[:host_goal], match.host_team_goal
      assert_equal m[:guest_goal], match.guest_team_goal
    
      match = OfficialMatch.find(1)
      assert_equal m[:host_name], match.host_team_name
      assert_equal m[:guest_name], match.guest_team_name
      assert_equal m[:start_time], match.start_time
      assert_equal m[:host_goal], match.host_team_goal
      assert_equal m[:guest_goal], match.guest_team_goal
    end
    end

    m = {
      :finished => false,
      :host_name => 'Inter Milan',
      :guest_name => 'AC Milan',
      :host_goal => 7,
      :guest_goal => 3,
      :start_time => OfficialMatch.find(1).start_time
    }

    assert_no_difference "OfficialMatch.count" do
    assert_no_difference "OfficialTeam.count" do
      new_teams = [];
      new_match = [];
      update_match = [];
      OfficialMatch.import_match(m) do |nt, nm, um|
        new_teams << nt
        new_teams.flatten!
        new_match << nm
        new_match.flatten!
        update_match << um
        update_match.flatten!
      end

      assert_equal 0, new_teams.length
      assert_equal 0, new_match.length
      assert_equal 1, update_match.length, "update result"

      match = update_match[0]
      assert_equal m[:host_name], match.host_team_name
      assert_equal m[:guest_name], match.guest_team_name
      assert_equal m[:start_time], match.start_time
      assert_equal m[:host_goal], match.host_team_goal
      assert_equal m[:guest_goal], match.guest_team_goal
    
      match = OfficialMatch.find(1)
      assert_equal m[:host_name], match.host_team_name
      assert_equal m[:guest_name], match.guest_team_name
      assert_equal m[:start_time], match.start_time
      assert_equal m[:host_goal], match.host_team_goal
      assert_equal m[:guest_goal], match.guest_team_goal
    end
    end

    m = {
      :finished => false,
      :host_name => 'Inter Milan',
      :guest_name => 'AC Milan',
      :host_goal => 7,
      :guest_goal => 3,
      :start_time => OfficialMatch.find(1).start_time + 36.hours - 1.minutes
    }

    assert_no_difference "OfficialMatch.count" do
    assert_no_difference "OfficialTeam.count" do
      new_teams = [];
      new_match = [];
      update_match = [];
      OfficialMatch.import_match(m) do |nt, nm, um|
        new_teams << nt
        new_teams.flatten!
        new_match << nm
        new_match.flatten!
        update_match << um
        update_match.flatten!
      end

      assert_equal 0, new_teams.length
      assert_equal 0, new_match.length
      assert_equal 1, update_match.length, "update start time add 14:59"

      match = update_match[0]
      assert_equal m[:host_name], match.host_team_name
      assert_equal m[:guest_name], match.guest_team_name
      assert_equal m[:start_time], match.start_time
      assert_equal m[:host_goal], match.host_team_goal
      assert_equal m[:guest_goal], match.guest_team_goal
    
      match = OfficialMatch.find(1)
      assert_equal m[:host_name], match.host_team_name
      assert_equal m[:guest_name], match.guest_team_name
      assert_equal m[:start_time], match.start_time
      assert_equal m[:host_goal], match.host_team_goal
      assert_equal m[:guest_goal], match.guest_team_goal
    end
    end

    m = {
      :finished => false,
      :host_name => 'Inter Milan',
      :guest_name => 'AC Milan',
      :host_goal => 7,
      :guest_goal => 3,
      :start_time => OfficialMatch.find(1).start_time - 36.hours + 1.minutes
    }

    assert_no_difference "OfficialMatch.count" do
    assert_no_difference "OfficialTeam.count" do
      new_teams = [];
      new_match = [];
      update_match = [];
      OfficialMatch.import_match(m) do |nt, nm, um|
        new_teams << nt
        new_teams.flatten!
        new_match << nm
        new_match.flatten!
        update_match << um
        update_match.flatten!
      end

      assert_equal 0, new_teams.length
      assert_equal 0, new_match.length
      assert_equal 1, update_match.length, "update start time minus 14:59:59"

      match = update_match[0]
      assert_equal m[:host_name], match.host_team_name
      assert_equal m[:guest_name], match.guest_team_name
      assert_equal m[:start_time], match.start_time
      assert_equal m[:host_goal], match.host_team_goal
      assert_equal m[:guest_goal], match.guest_team_goal
    
      match = OfficialMatch.find(1)
      assert_equal m[:host_name], match.host_team_name
      assert_equal m[:guest_name], match.guest_team_name
      assert_equal m[:start_time], match.start_time
      assert_equal m[:host_goal], match.host_team_goal
      assert_equal m[:guest_goal], match.guest_team_goal
    end
    end

    m = {
      :finished => false,
      :host_name => 'Inter Milan',
      :guest_name => 'AC Milan',
      :host_goal => 7,
      :guest_goal => 3,
      :start_time => OfficialMatch.find(1).start_time + 36.hours
    }

    assert_difference "OfficialMatch.count", 1 do
    assert_no_difference "OfficialTeam.count" do
      new_teams = [];
      new_match = [];
      update_match = [];
      OfficialMatch.import_match(m) do |nt, nm, um|
        new_teams << nt
        new_teams.flatten!
        new_match << nm
        new_match.flatten!
        update_match << um
        update_match.flatten!
      end

      assert_equal 0, new_teams.length
      assert_equal 1, new_match.length, "new match start time add 36 hours"
      assert_equal 0, update_match.length

      match = new_match[0]
      assert_equal m[:host_name], match.host_team_name
      assert_equal m[:guest_name], match.guest_team_name
      assert_equal m[:start_time], match.start_time
      assert_equal m[:host_goal], match.host_team_goal
      assert_equal m[:guest_goal], match.guest_team_goal
    end
    end

    m = {
      :finished => false,
      :host_name => 'Inter Milan',
      :guest_name => 'AC Milan',
      :host_goal => 7,
      :guest_goal => 3,
      :start_time => OfficialMatch.find(1).start_time - 36.hours
    }

    assert_difference "OfficialMatch.count", 1 do
    assert_no_difference "OfficialTeam.count" do
      new_teams = [];
      new_match = [];
      update_match = [];
      OfficialMatch.import_match(m) do |nt, nm, um|
        new_teams << nt
        new_teams.flatten!
        new_match << nm
        new_match.flatten!
        update_match << um
        update_match.flatten!
      end

      assert_equal 0, new_teams.length
      assert_equal 1, new_match.length, "new match start time minus 36 hours"
      assert_equal 0, update_match.length

      match = new_match[0]
      assert_equal m[:host_name], match.host_team_name
      assert_equal m[:guest_name], match.guest_team_name
      assert_equal m[:start_time], match.start_time
      assert_equal m[:host_goal], match.host_team_goal
      assert_equal m[:guest_goal], match.guest_team_goal
    end
    end
  end
end
