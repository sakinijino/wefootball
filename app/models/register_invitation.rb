class RegisterInvitation < ActiveRecord::Base
  validates_length_of       :message, :maximum => 500 
  validates_format_of       :login, 
    :with=> /^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/,
    :message => 'E-mail好像填得有些小问题...'
  def create_invitation_code
    self.invitation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )    
    save(false)
  end
end
