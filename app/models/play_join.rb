class PlayJoin < ActiveRecord::Base
  belongs_to :play
  belongs_to :user
  
  def after_destroy
    if PlayJoin.find_all_by_play_id(self.play_id).empty?
      Play.destroy(self.play_id)
    end
  end
  
end
