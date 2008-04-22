class SitePost < ActiveRecord::Base
  belongs_to :user
  
  has_many :site_replies, :dependent => :destroy
  
  validates_presence_of     :title, :message => "标题不能为空"
  validates_length_of :title, :maximum =>100, :message => "标题最长为100个字"
  validates_length_of :content, :minimum =>2, :message => "内容太短了, 最少也写2个字吧"
  
  validates_format_of       :email, 
    :with=> /^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/,
    :message => '需要填写Email', :allow_nil => true
  validates_length_of        :email,    :maximum => 100, :message=>'Email太长了吧', :allow_nil => true
  
  attr_accessible :title, :content, :email
  
  def before_validation
    self.email = nil if self.email.blank?
  end
  
  def can_be_destroyed_by?(user)
    self.user_id == get_user_id(user)
  end

private
  def get_user_id(user)
    case user
    when User
      user.id
    else
      user
    end
  end
end
