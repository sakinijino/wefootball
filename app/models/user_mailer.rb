class UserMailer < ActionMailer::Base
  def signup_notification(user)   
    setup_email(user)
    @subject    += '请激活你的帐号'
  
    @body[:url]  = "#{HOST}/activate/#{user.activation_code}"
  
  end
  
  def invite_notification(host, invitation, message)   
    setup_invitation_email(invitation)
    @subject    += "#{host.nickname}邀请你使用WeFootball"
    @body[:signup_url]  = "#{HOST}/signup_with_invitation/#{invitation.invitation_code}"    
    @body[:host_url]  = "#{HOST}/user_views/#{host.id}"
    @body[:host] = host
    @body[:message] = message    
  end  
  
  def activation(user)
    setup_email(user)
    @subject    += '你的帐号已经被激活！'
    @body[:main_page_url]  = "#{HOST}/user_views/#{user.id}"
    @body[:edit_url]  = "#{HOST}/users/#{user.id}/edit"  
  end
  
  def forgot_password(user)
    setup_email(user)
    @subject    += '你要求更改密码'
    @body[:url]  = "#{HOST}/reset_password/#{user.password_reset_code}" 
  end

  def reset_password(user)
    setup_email(user)
    @subject    += '你的密码已经被更改'
    @body[:url]  = "#{HOST}/login"    
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.login}"
      @from        = %("WeFootball" <welcome@wefootball.org>) # Sets the User FROM Name and Email
      @subject     = "[WeFootball]"
      @sent_on     = Time.now
      @body[:user] = user
    end
    
    def setup_invitation_email(invitation)
      @recipients  = "#{invitation.login}"
      @from        = %("WeFootball" <welcome@wefootball.org>) # Sets the User FROM Name and Email
      @subject     = "[WeFootball]"
      @sent_on     = Time.now
      @body[:invitation] = invitation
    end    

end