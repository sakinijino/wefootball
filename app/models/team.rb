class Team < ActiveRecord::Base
  include ModelHelper

  FORMATION_POSITIONS =  (0...26).to_a
  DEFAULT_IMAGE = "/images/default_team.gif"
          
  has_one :team_image,
            :dependent => :destroy
  
  has_many :trainings, :dependent => :destroy, :extend => ActivityCalendar
  
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
          
  has_many :match_joins,
            :dependent => :destroy

  has_many :host_matches,:foreign_key=>"host_team_id",:class_name=>"Match",
            :extend => ActivityCalendar
  has_many :guest_matches,:foreign_key=>"guest_team_id",:class_name=>"Match",
            :extend => ActivityCalendar          
  
  has_many :posts, :dependent => :destroy, :order => "updated_at desc" do
    def public
      find :all, :conditions => ['is_private = ?', false]
    end
  end
  
  validates_presence_of     :name, :shortname
  validates_length_of        :name,    :maximum => 50
  validates_length_of        :shortname,    :maximum => 15
  validates_length_of        :summary,    :maximum => 3000, :allow_nil=>true
  validates_length_of        :style,    :maximum => 50
  
  attr_protected :uploaded_data
  
  def before_validation
    attribute_slice(:name, 50)
    attribute_slice(:shortname, 15)
    attribute_slice(:summary, 3000)
    attribute_slice(:style, 50)
  end

  def self.find_by_contents(q)
    Team.find :all, :conditions => ["name like ? or shortname like ?", q, q]
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
  
  def matches
    m = self.host_matches + self.guest_matches
    def m.team=(t)
      @team = t
    end
    m.team = self
    def m.method_missing(method_id, *args)
      @team.host_matches.send(method_id, *args) + @team.guest_matches.send(method_id, *args)  
    end
    m
  end
  
  class MatchProxy
    def initialize(match)
      @object = match
    end
    
    def method_missing(method_id, *args)
      @object.host_matches.send(method_id, *args) + @object.guest_matches.send(method_id, *args)
    end
  end
  
end
