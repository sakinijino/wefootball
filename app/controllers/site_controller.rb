class SiteController < ApplicationController
  def index
    @users = User.find(:all, :conditions=>"activated_at is not null", :limit => 9, :order => 'id desc')
    @teams = Team.find(:all, :limit => 9, :order => 'id desc')
    
    tmp = []
    tmp += Training.find(:all, :limit => 1, :conditions => ['end_time > ?', Time.now], :order=>'start_time')
    tmp += Match.find(:all, :limit => 1, :conditions => ['end_time > ?', Time.now], :order=>'start_time')
    tmp += SidedMatch.find(:all, :limit => 1, :conditions => ['end_time > ?', Time.now], :order=>'start_time')
    tmp += Play.find(:all, :limit => 1, :conditions => ['end_time > ?', Time.now], :order=>'start_time')
    tmp += Watch.find(:all, :limit => 1, :conditions => ['end_time > ?', Time.now], :order=>'start_time')
    tmp = tmp.sort_by{|act| act.start_time}
    if (tmp.length >0)
      @start_time = tmp[0].start_time.yesterday
      @end_time = tmp[-1].end_time.tomorrow
      @activities = tmp.group_by{|t| t.start_time.strftime("%Y-%m-%d")}
    else
      @activities = {}
    end
    
    @bcs = Broadcast.find(:all, :limit => 5*2, :order => 'id desc')
    @bcs = @bcs.reject do |item| 
      (((item.class == FriendCreationBroadcast) && (item.user_id < item.friend_id)) ||
          ((item.class == MatchCreationBroadcast) && (item.team_id == item.match.guest_team_id)))
    end
    @bcs = @bcs.slice(0,5)
    
    @official_matches = OfficialMatch.find :all, 
      :conditions => ['end_time > ? and start_time < ?', Time.now, OfficialMatchesController::RECENT_DAYS.days.since],
      :order=>'watch_join_count DESC, start_time',
      :limit => 3
    
    @history_official_matches = OfficialMatch.find :all, 
      :conditions => ['end_time > ? and end_time < ?', OfficialMatchesController::HISTORY_DAYS.days.ago, Time.now],
      :order=>'watch_join_count desc, start_time desc',
      :limit => 5
    
    @reviews = MatchReview.find( :all,
      :conditions => ['created_at > ?', 3.days.ago], 
      :limit=>5,
      :order => 'like_count-dislike_count desc, like_count desc, created_at desc')
    
    @title = "WeFootball - 没事儿踢踢球才是正经事~"
    render :layout =>"user_layout"
  end
  
  def about
    @title = "关于WeFootball"  
    render :layout =>"user_layout"
  end
  
  def faq
    @title = "WeFootball常见问题"  
    render :layout =>"user_layout"
  end
  
  def privacy
    @title = "WeFootball隐私原则"
    render :layout =>"user_layout"
  end
end
