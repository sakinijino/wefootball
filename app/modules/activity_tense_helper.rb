module ActivityTenseHelper  
  def icon
    self.class::ICON
  end
  
  def img_title
    self.class::IMG_TITLE
  end
  
  def time_status_text
    self.class::TIME_STATUS_TEXTS[time_key]
  end
  
  def join_status_text(user, team=nil)
    self.class::JOIN_STATUS_TEXTS[time_key][join_key(user, team)]
  end
  
  def join_links_text(user, team=nil)
    self.class::JOIN_LINKS_TEXTS[time_key][join_key(user, team)]
  end
  
  protected
  def time_key
    if !started?
      :before
    elsif finished?
      :after
    else
      :in
    end
  end
  
  def join_key(user, team=nil)
    if has_joined_member?(user)
      :joined
    elsif has_member?(user)
      :undetermined
    else
      :unjoined
    end
  end
end

module MatchTenseHelper
  ICON = "match_icon.gif"
  IMG_TITLE = "比赛"
  TIME_STATUS_TEXTS = {
    :before => nil,
    :in => '比赛正在进行',
    :after => '比赛已结束'
  }
  
  JOIN_STATUS_TEXTS = {
    :before =>{
      :joined => '我打算去',
      :undetermined => '要去吗?',
      :unjoined => '我不打算去',
    },
    :in => {
      :joined => '我正在比赛',
      :undetermined => '要去吗?',
    },
    :after => {
      :joined => '我去了',
      :undetermined => '参加了吗?',
      :unjoined => '我没去',
    }
  }
  
  JOIN_LINKS_TEXTS = {
    :before =>{
      :joined => ['---', '不去了'],
      :undetermined => ['要去', '不去'],
      :unjoined => ['打算去', '---']
    },
    :in =>{
      :joined => ['---', '没去'],
      :undetermined => ['现在去', '不去'],
      :unjoined => ['现在去', '---']
    },
    :after =>{
      :joined => ['---', '没去'],
      :undetermined => ['我去了', '我没去'],
      :unjoined => ['去了', '---']
    }
  }
  
  SIDED_JOIN_STATUS_TEXTS = {
    :before =>{
      :joined => "我要代表%s参赛",
      :undetermined => "代表%s参赛?",
      :unjoined => "我不打算代表%s参赛",
    },
    :in => {
      :joined => "我正代表%s参赛",
      :undetermined => "我没说是否代表%s参赛",
      :unjoined => "我没代表%s参赛",
    },
    :after => {
      :joined => "我代表%s参赛了",
      :undetermined => "我没说是否代表%s参赛",
      :unjoined => "我没代表%s参赛",
    }
  }
  
  def sided_join_status_text(user, team, team_name)
    SIDED_JOIN_STATUS_TEXTS[time_key][join_key(user, team)] % (team_name ? team_name : team.shortname)
  end
  
  protected
  def join_key(user, team)
    if has_joined_team_member?(user, team)
      :joined
    elsif has_team_member?(user, team)
      :undetermined
    else
      :unjoined
    end
  end
end

module SidedMatchTenseHelper
  ICON = "match_icon.gif"
  IMG_TITLE = "比赛"
  TIME_STATUS_TEXTS = MatchTenseHelper::TIME_STATUS_TEXTS
  JOIN_STATUS_TEXTS = MatchTenseHelper::JOIN_STATUS_TEXTS
  JOIN_LINKS_TEXTS = MatchTenseHelper::JOIN_LINKS_TEXTS
end

module TrainingTenseHelper
  ICON = "training_icon.gif"
  IMG_TITLE = "训练"
  TIME_STATUS_TEXTS = {
    :before => nil,
    :in => '比赛正在进行',
    :after => '比赛已结束'
  }
  
  JOIN_STATUS_TEXTS = {
    :before =>{
      :joined => '我打算去',
      :undetermined => '要去吗?',
      :unjoined => '我不打算去',
    },
    :in => {
      :joined => '我正在训练',
      :undetermined => '要去吗?',
      :unjoined => '我没去',
    },
    :after => {
      :joined => '我去了',
      :undetermined => '参加了吗?',
      :unjoined => '我没去',
    }
  }
  
  JOIN_LINKS_TEXTS = {
    :before =>{
      :joined => ['---', '不去了'],
      :undetermined => ['要去', '不去'],
      :unjoined => ['打算去', '---']
    },
    :in =>{
      :joined => ['---', '没去'],
      :undetermined => ['现在去', '不去'],
      :unjoined => ['现在去', '---']
    },
    :after =>{
      :joined => ['---', '没去'],
      :undetermined => ['我去了', '我没去'],
      :unjoined => ['去了', '---']
    }
  }
end

module PlayTenseHelper
  ICON = "play_icon.gif"
  IMG_TITLE = "随便踢踢"
  
  TIME_STATUS_TEXTS = {
    :before => nil,
    :in => '正在进行',
    :after => '结束了'
  }
  
  JOIN_STATUS_TEXTS = {
    :before =>{
      :joined => '我要去踢',
    },
    :in => {
      :joined => '我正在踢',
    },
    :after => {
      :joined => '我去了',
    }
  }
  
  JOIN_LINKS_TEXTS = {
    :before =>{
      :joined => ['---', '不去了'],
      :unjoined => ['要去', '---']
    },
    :in =>{
      :joined => ['---', '没去'],
      :unjoined => ['现在去', '---']
    },
    :after =>{
      :joined => ['---', '没去'],
      :unjoined => ['去了', '---']
    }
  }
  
  protected
  def join_key(user, team=nil)
    if has_member?(user)
      :joined
    else
      :unjoined
    end
  end
end

module WatchTenseHelper
  ICON = "watch_icon.gif"
  IMG_TITLE = "看球"
  
  TIME_STATUS_TEXTS = {
    :before => nil,
    :in => '正在进行',
    :after => '结束了'
  }
  
  JOIN_STATUS_TEXTS = {
    :before =>{
      :joined => '我要去',
    },
    :in => {
      :joined => '正在看',
    },
    :after => {
      :joined => '我去了',
    }
  }
  
  JOIN_LINKS_TEXTS = {
    :before =>{
      :joined => ['---', '不去了'],
      :unjoined => ['要去', '---']
    },
    :in =>{
      :joined => ['---', '没去'],
      :unjoined => ['现在去', '---']
    },
    :after =>{
      :joined => ['---', '没去'],
      :unjoined => ['去了', '---']
    }
  }
  
  protected
  def join_key(user, team=nil)
    if has_member?(user)
      :joined
    else
      :unjoined
    end
  end
end