class SitePostAdmin < ActiveRecord::Base
  def self.is_an_admin?(user)
    user_id = case user
    when User
      user.id
    else
      user
    end
    SitePostAdmin.find_by_user_id(user_id) != nil
  end
end
