class RegisterInvitation < ActiveRecord::Base
  validates_format_of       :login, 
    :with=> /^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/,
    :message => '需要填写Email'
  def create_invitation_code
    self.invitation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )    
    save(false)
  end
end
