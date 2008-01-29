require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password
  has_many :positions,
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
  has_many :trainings, :through=>:training_joins

  validates_presence_of     :login, :nickname
  validates_format_of       :login, 
    :with=> /^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/,
    :message => ' should be an E-mail address'
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of        :login,    :within => 3..40
  validates_uniqueness_of   :login, :case_sensitive => false
  
  validates_inclusion_of    :weight, :in => 0..400, :allow_nil =>true,
    :message => '... Are you kidding me?'
  validates_inclusion_of    :height, :in => 0..250, :allow_nil =>true,
    :message => '... Are you kidding me?'
  validates_inclusion_of    :fitfoot, :in => %w{L B R}, :allow_nil =>true
  validates_length_of       :nickname, :maximum => 70
  validates_length_of       :summary, :maximum => 500

  GENERIC_ANALYSIS_REGEX = /([a-zA-Z]|[\xc0-\xdf][\x80-\xbf])+|[0-9]+|[\xe0-\xef][\x80-\xbf][\x80-\xbf]/
  GENERIC_ANALYZER = Ferret::Analysis::RegExpAnalyzer.new(GENERIC_ANALYSIS_REGEX, true)  
#  GENERIC_ANALYZER = MultilingualFerretTools::Analyzer.new
#  GENERIC_ANALYZER = Ferret::Analysis::StandardAnalyzer.new
  acts_as_ferret({:fields => [
        :login,
        :nickname
      ]},
    { :analyzer => GENERIC_ANALYZER })
  
  before_save :encrypt_password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :password, :password_confirmation
  attr_accessible :weight, :height, :fitfoot, :nickname, :summary, :birthday

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

  def friends
    friends_id_list = FriendRelation.find(:all,
                                          :select => 'user1_id, user2_id',
                                          :conditions => ["user1_id=:uid or user2_id=:uid",{:uid=>self.id}]
                                         )
                   
    friends_id_list = (friends_id_list.map{|x|[x.user1_id,x.user2_id]}).flatten.reject {|id| id == self.id}
    User.find(friends_id_list)
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
    
end
