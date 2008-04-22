require 'digest/sha1'
class User < ActiveRecord::Base
  include ModelHelper
  
  FITFOOT = %w{R L B}
  DEFAULT_IMAGE = "/images/default_user.gif"
  UNCHOSED_POSITION = -1
  
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

  has_many :match_joins,
            :dependent => :destroy
  has_many :matches, :through=>:match_joins, :select => "distinct matches.*", :extend => ActivityCalendar
  
  has_many :play_joins,
            :dependent => :destroy
  has_many :plays, :through=>:play_joins, :extend => ActivityCalendar
  
  has_many :sided_match_joins,
            :dependent => :destroy
  has_many :sided_matches, :through=>:sided_match_joins, :extend => ActivityCalendar
  
  has_many :posts, :dependent => :destroy

  validates_presence_of     :login, :message=>'请填写Email'
  validates_presence_of     :nickname, :message=>'请填写昵称'
  validates_format_of       :login, 
    :with=> /^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/,
    :message => '需要用Email注册'
  validates_presence_of     :password,                   :if => :password_required?, :message=>'请填写密码'
  validates_presence_of     :password_confirmation,      :if => :password_required?, :message=>'请确认密码'
  validates_length_of     :password, :minimum =>4, :message => "密码最少需要填写4位", :if => :password_required?
  validates_length_of       :password, :maximum =>40, :message => "密码最长可以填40位", :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?, :message=>'填写的密码不一致'
  validates_length_of        :login,    :minimum => 3, :message=>''
  validates_length_of        :login,    :maximum => 40, :message=>'Email太长了吧'
  validates_uniqueness_of   :login, :case_sensitive => false, :message=>'这个Email已经被注册过了'
  
  validates_length_of       :nickname, :maximum => 15, :message=>'昵称最长可以填15个字'
  validates_inclusion_of    :birthday_display_type, :in => [0, #不显示生日
    1, #显示年月日
    2, #显示月日
    3 #显示年
  ], :message => "不要自己构造表单提交..."
  validates_inclusion_of    :gender, :in => [0, #未填
    1, #男
    2, #女
  ], :message => "不要自己构造表单提交..."
  validates_inclusion_of   :city, :in => ProvinceCity::CITY_VALUE_RANGE, :message => "不要自己构造表单提交..."
  validates_length_of       :summary, :maximum => 3000, :allow_nil=>true, :message => "个人简介最长可以填3000个字"
  validates_length_of       :favorite_star, :maximum => 200, :message => "最喜欢的球星最长可以填200个字"
  validates_length_of       :favorite_team, :maximum => 200, :message => "最喜欢的球队最长可以填200个字"
  validates_length_of       :blog, :maximum => 256, :message => "blog地址最长可以填256个字"
  validates_format_of       :full_blog_uri, :allow_nil => true,
     :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$)/ix,
     :if => Proc.new {|u| !u.blog.blank?}, :message => "blog地址必须是一个url"
  
  validates_numericality_of :weight, :height, :if=>:is_playable, :allow_nil=>true, :message => "身高体重需要填写数字"
  validates_inclusion_of    :weight, :in => 0..400, :if=>:is_playable,
    :message => '体重填的不太对吧……', :allow_nil=>true
  validates_inclusion_of    :height, :in => 0..250, :if=>:is_playable,
    :message => '身高填的不太对吧……', :allow_nil=>true
  validates_inclusion_of    :fitfoot, :in => FITFOOT, :if=>:is_playable, :message => "不要自己构造表单提交..."
  validates_inclusion_of   :premier_position, :in => Position::POSITIONS, :if=>:is_playable, :message => "不要自己构造表单提交..."
  
  validates_multiparameter_assignments :message => "无效的生日日期" 
  
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
  
  def after_save
    if (!self.is_playable)
      ids = UserTeam.find_all_by_user_id_and_is_player(self.id, true).map {|ut| ut.id}
      UserTeam.update(ids, [{:is_player => false}]*ids.length)
    end
  end
  
  before_save :encrypt_password
  before_create :make_activation_code  
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :password, :password_confirmation
  attr_accessible :nickname, :summary, :birthday, :birthday_display_type, :city, :favorite_star, :favorite_team, :gender, :blog
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
    User.find :all, :conditions => ["(login like ? or nickname like ?) and activated_at is not null", "%#{q}%", "%#{q}%"]
  end

 # Activates the user in the database.
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
    UserMailer.deliver_activation(self)
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  def create_password_reset_code
    self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )    
    save(false)
  end
  
  def delete_password_reset_code
    self.password_reset_code = nil
    save(false)    
  end  
  
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  def self.correct_login_without_activation(login, password)
    u = find :first, :conditions => ['login = ? and activated_at IS NULL', login] # need to get the salt
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
  
  def image(thumbnail = nil, refresh = nil)
    if refresh == :refresh && self.user_image != nil
      self.image_path = self.user_image.public_filename
      self.save
      return self.user_image.public_filename(thumbnail)
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
    !match_invitation.outdated? && can_act_on_match_invitation?(match_invitation)
  end  
  
  def can_reject_match_invitation?(match_invitation)
    can_act_on_match_invitation?(match_invitation)
  end
  
  def full_blog_uri
    "http://#{self.blog}"
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
    
    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end    
    
    def can_act_on_match_invitation?(match_invitation)
      if match_invitation.edit_by_host_team == true
        return self.is_team_admin_of?(match_invitation.host_team_id)
      else
        return self.is_team_admin_of?(match_invitation.guest_team_id)
      end
    end  
end
