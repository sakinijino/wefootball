module PlaysHelper  
  def play_status_with_logged_in(play,user)
    status = ""
    if Time.now < play.start_time
      status = "尚未开始"
      if !PlayJoin.find_by_play_id_and_user_id(play.id,user.id)
        status += "，我没说会去"
      else
        status += "，我要去"
      end
    else
      if Time.now >= play.start_time && Time.now <= play.end_time
        return "进行中"
      else
        return "已结束"
      end
      if !PlayJoin.find_by_play_id_and_user_id(play.id,user.id)
        status += "，我去了"
      else
        status += "，我没去"
      end
    end
  end
  
  def play_status_with_unlogged_in(play)
    status = ""
    if Time.now < play.start_time
      status = "尚未开始"
    elsif Time.now >= play.start_time && Time.now <= play.end_time
      return "进行中"
    else
      return "已结束"
    end
  end   
end
