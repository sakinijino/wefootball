class OfficialTeamEditor < ActiveRecord::Base
  def self.is_a_editor?(user)
    user_id = case user
    when User
      user.id
    else
      user
    end
    OfficialTeamEditor.find_by_user_id(user_id) != nil
  end
end
