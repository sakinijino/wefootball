class Team < ActiveRecord::Base
  include ModelHelper

  FORMATION_POSITIONS =  (0...26).to_a
  DEFAULT_IMAGE = "/images/default_team.gif"
          
  has_one :team_image,
            :dependent => :destroy
  
  has_many :user_teams,
            :dependent => :destroy
  has_many :users, :through=>:user_teams do
    def admin
      find :all, :conditions => ['is_admin = ?', true]
    end
    def players
      find :all, :conditions => ['is_player = ?', true]
    end
  end
  
  has_many :team_join_requests,
            :dependent => :destroy

  has_many :trainings, :dependent => :destroy, :extend => ActivityCalendar
  has_many :sided_matches, :foreign_key=>"host_team_id", :dependent => :destroy, :extend => ActivityCalendar

  has_many :host_matches,:foreign_key=>"host_team_id",:class_name=>"Match",
            :dependent => :destroy,
            :extend => ActivityCalendar
  has_many :guest_matches,:foreign_key=>"guest_team_id",:class_name=>"Match",
            :dependent => :destroy,
            :extend => ActivityCalendar          
  
  has_many :posts, :dependent => :destroy, :order => "updated_at desc" do
    def public(options={})
      find :all, {:conditions => ['is_private = ?', false]}.merge(options)
    end
  end
  
  validates_presence_of     :shortname, :message => "请填写队名"
  validates_length_of        :name, :maximum => 50, :message => "球队全名最长可以填50个字"
  validates_length_of        :shortname,    :maximum => 15, :message => "队名最长可以填15个字"
  validates_length_of        :summary,    :maximum => 3000, :allow_nil=>true, :message => "球队简介最长可以填3000个字"
  validates_length_of        :style,    :maximum => 50, :message => "球队风格最长可以填15个字"
  validates_inclusion_of   :city, :in => ProvinceCity::CITY_VALUE_RANGE, :message => "不要自己构造表单提交..."
  
  validates_multiparameter_assignments :message => "无效的建队日期" 
  
  attr_protected :uploaded_data
  
  def before_validation
    attribute_slice(:summary, 3000)
    attribute_slice(:style, 50)
  end

  def self.find_by_contents(q)
    Team.find :all, :conditions => ["name like ? or shortname like ?", "%#{q}%", "%#{q}%"]
  end
  
  def image(thumbnail = nil, refresh = nil)
    if refresh == :refresh && self.team_image != nil
      self.image_path = self.team_image.public_filename
      self.save
      return self.team_image.public_filename(thumbnail) 
    end
    if self.image_path != nil
      if thumbnail == nil
        self.image_path
      else
        self.image_path.split('.').insert(1, "_#{thumbnail}.").join
      end
    else
      if thumbnail == nil
        DEFAULT_IMAGE
      else
        DEFAULT_IMAGE.split('.').insert(1, "_#{thumbnail}.").join
      end
    end
  end
  
  def formation
    UserTeam.team_formation(self)
  end
  
  def match_calendar_proxy
    MatchCalendarProxy.new(self)
  end
  
  class MatchCalendarProxy
    def initialize(match)
      @object = match
    end
    
    def method_missing(method_id, *args)
      @object.host_matches.send(method_id, *args) + @object.guest_matches.send(method_id, *args)
    end
  end
  
end
