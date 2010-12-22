class SiteReply < ActiveRecord::Base
  belongs_to :user
  belongs_to :site_post, :counter_cache => true
  
  validates_length_of :content, :minimum =>2, :message => "内容太短了, 最少也写2个字吧"
  
  validates_format_of       :email, 
    :with=> /^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/,
    :message => '填写的必须是一个Email地址', :allow_nil => true
  validates_length_of        :email,    :maximum => 100, :message=>'Email太长了吧', :allow_nil => true
  
  attr_accessible :content, :email
  
  def before_validation
    self.email = nil if self.email.blank?
  end
  
  def can_be_destroyed_by?(user)
    self.user_id == get_user_id(user) || SitePostAdmin.is_an_admin?(user)
  end

  def after_save
    SitePost.update_all(["updated_at = ?", Time.now], :id => [self.site_post_id]) if !self.site_post_id.blank?
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
