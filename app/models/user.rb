require 'digest/sha1'
class User < ActiveRecord::Base
  include ModelHelper
  
  FITFOOT = %w{R L B}
  DEFAULT_IMAGE = "/images/default_user.jpg"
  
  attr_accessor :password
  has_many :positions,
            :dependent => :destroy
  has_one :user_image,
            :dependent => :destroy
  
  has_many :sent_messages, :class_name=>"Message", :foreign_key=>"sender_id",
            :dependent => :destroy
  has_many :received_messages, :class_name=>"Message", :foreign_key=>"receiver_id",
            :dependent => :destroy
  
  has_many :user_teams,
            :dependent => :destroy
  has_many :teams, :through=>:user_teams do
    def admin
      find :all, :conditions => ['is_admin = ?', true]
    end
  end
  
  has_many :team_join_requests,
            :dependent => :destroy
  
  has_many :training_joins,
            :dependent => :destroy
  has_many :trainings, :through=>:training_joins, :extend => ActivityCalendar
  
  has_many :posts, :dependent => :destroy

  validates_presence_of     :login, :nickname
  validates_format_of       :login, 
    :with=> /^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/,
    :message => '需要用E-mail注册'
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of        :login,    :within => 3..40
  validates_uniqueness_of   :login, :case_sensitive => false
  
  validates_length_of       :nickname, :maximum => 15
  validates_inclusion_of    :birthday_display_type, :in => [0, #不显示生日
    1, #显示年月日
    2, #显示月日
    3 #显示年
  ], :allow_nil=>true
  validates_inclusion_of   :city, :in => ProvinceCity::CITY_VALUE_RANGE
  validates_length_of       :summary, :maximum => 3000, :allow_nil=>true
  validates_length_of       :favorite_star, :maximum => 200
  validates_length_of       :favorite_team, :maximum => 200
  
  validates_numericality_of :weight, :height, :if=>:is_playable, :allow_nil=>true
  validates_inclusion_of    :weight, :in => 0..400, :if=>:is_playable,
    :message => '... Are you kidding me?', :allow_nil=>true
  validates_inclusion_of    :height, :in => 0..250, :if=>:is_playable,
    :message => '... Are you kidding me?', :allow_nil=>true
  validates_inclusion_of    :fitfoot, :in => FITFOOT, :if=>:is_playable
  validates_inclusion_of   :premier_position, :in => Position::POSITIONS, :if=>:is_playable
  
  def before_validation
    self.nickname = self.login.split('@')[0] if self.login!=nil && (self.nickname==nil || self.nickname == "")
    attribute_slice(:nickname, 15)
    attribute_slice(:favorite_star, 200)
    attribute_slice(:favorite_team, 200)
    attribute_slice(:summary, 3000)
    self.weight = nil if self.weight == ''
    self.height = nil if self.height == ''
  end
  
  def before_save
    if (!self.is_playable)
      self.weight = nil
      self.height = nil
      self.fitfoot = nil
      self.premier_position = nil
      self.positions.clear
    else
      self.positions<< Position.new({:label=>self.premier_position}) if !self.positions.map {|p| p.label}.include?(self.premier_position)
    end
  end
  
  before_save :encrypt_password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :password, :password_confirmation
  attr_accessible :nickname, :summary, :birthday, :birthday_display_type, :city, :favorite_star, :favorite_team
  attr_accessible :is_playable, :weight, :height, :fitfoot, :premier_position
  
#  GENERIC_ANALYSIS_REGEX = /([a-zA-Z]|[\xc0-\xdf][\x80-\xbf])+|[0-9]+|[\xe0-\xef][\x80-\xbf][\x80-\xbf]/
#  GENERIC_ANALYZER = Ferret::Analysis::RegExpAnalyzer.new(GENERIC_ANALYSIS_REGEX, true)  
##  GENERIC_ANALYZER = MultilingualFerretTools::Analyzer.new
##  GENERIC_ANALYZER = Ferret::Analysis::StandardAnalyzer.new
#  acts_as_ferret({:fields => [
#        :login,
#        :nickname
#      ]},
#    { :analyzer => GENERIC_ANALYZER })

  def self.find_by_contents(q)
    User.find :all, :conditions => ["login like ? or nickname like ?", q, q]
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{login}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  def positions_array
    self.positions.map {|p| p.label}
  end
  
  def positions_array=(arr)
    arr = [] if arr==nil
    # poor performance, need refactoring
    arr.uniq!
    ps = []
    for label in arr
      ps<<Position.new({:label=>label})
    end
    self.positions.replace(ps)
  end
  
  def is_my_friend?(user)
    FriendRelation.are_friends?(self.id, user.id)
  end

  def friends(limit=nil)
    friends_list = FriendRelation.find(:all,
                                          :select => 'user1_id, user2_id',
                                          :conditions => ["user1_id=:uid or user2_id=:uid",{:uid=>self.id}],
                                          :limit=>limit,
                                          :include=>[:user1, :user2]
                                         )
    friends_list.map{|fr|[fr.user1, fr.user2]}.flatten.reject {|u| u==self}
  end
  
  def image(thumbnail = nil)
    return self.user_image.public_filename(thumbnail) if self.user_image != nil
    DEFAULT_IMAGE
  end
  
  def is_team_admin_of?(team)
    team_id = case team
    when Team
      team.id
    else
      team
    end
    UserTeam.find_by_user_id_and_team_id_and_is_admin(self.id, team_id, true) != nil
  end
  
  def is_team_member_of?(team)
    team_id = case team
    when Team
      team.id
    else
      team
    end    
    UserTeam.find_by_user_id_and_team_id(self.id, team_id) != nil
  end
  
  def can_invite_team?(team)
    team_id = case team
    when Team
      team.id
    else
      team
    end
    !(self.teams.admin.empty?||(self.teams.admin.length == 1 && self.teams.admin[0].id == team_id))
  end
  
  def can_edit_match_invitation?(match_invitation)
    can_act_on_match_invitation?(match_invitation)
  end
  
  def can_accpet_match_invitation?(match_invitation)
    can_act_on_match_invitation?(match_invitation)
  end  
  
  def can_reject_match_invitation?(match_invitation)
    can_act_on_match_invitation?(match_invitation)
  end
  
  def can_edit_match?(team,match)
    can_act_on_match?(team,match)
  end
  
  def birthday_text
    return nil if self.birthday.nil?
    case self.birthday_display_type
    when 0
      nil
    when 1
      self.birthday.strftime("%Y年%m月%d日")
    when 2
      self.birthday.strftime("%m月%d日")
    when 3
      self.birthday.strftime("%Y年")
    else
      nil
    end
  end
  
  def age
    return nil if self.birthday.nil?
    case self.birthday_display_type
    when 1
      Date.today.year - self.birthday.year
    when 3
      Date.today.year - self.birthday.year
    else
      nil
    end
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    def can_act_on_match_invitation?(match_invitation)
      if match_invitation.edit_by_host_team == true
        return self.is_team_admin_of?(match_invitation.host_team_id)
      else
        return self.is_team_admin_of?(match_invitation.guest_team_id)
      end
    end
    
    def can_act_on_match?(team, match)      
      return self.is_team_admin_of?(team) && ((team==match.host_team_id.to_s)||(team==match.guest_team_id.to_s))      
    end    
end
