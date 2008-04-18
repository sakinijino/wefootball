module ActivitiesHelper
  STATUS_MATRIX = {
    :before =>{
      :training => {
        :time => nil,
        :joined => '我打算去',
        :undetermined => '要去吗?',
        :unjoined => '我不打算去',
      },
      :play => {
        :time => nil,
        :joined => '我要去踢',
      },
      :sided_match => {
        :time => nil,
        :joined => '我打算去',
        :undetermined => '要去吗?',
        :unjoined => '我不打算去',
      },
      :match => {
        :time => nil
      }
    },
    :in => {
      :training => {
        :time => '训练正在进行',
        :joined => '我正在训练',
        :undetermined => '要去吗?',
        :unjoined => '我没去',
      },
      :play => {
        :time => '正在进行',
        :joined => '我正在踢',
      },
      :sided_match => {
        :time => '比赛正在进行',
        :joined => '我正在比赛',
        :undetermined => '要去吗?',
        :unjoined => '我没去',
      },
      :match => {
        :time => '比赛正在进行',
      }
    },
    :after => {
      :training => {
        :time => '训练已结束',
        :joined => '我去了',
        :undetermined => '参加了吗?',
        :unjoined => '我没去',
      },
      :play => {
        :time => '结束了',
        :joined => '我去了',
      },
      :sided_match => {
        :time => '比赛已结束',
        :joined => '我去了',
        :undetermined => '参加了吗?',
        :unjoined => '我没去',
      },
      :match => {
        :time => '比赛已结束',
      }
    }
  }
    
  LINKS_MATRIX = {
    :before =>{
      :training => {
        :joined => ['---', '不去了'],
        :undetermined => ['要去', '不去'],
        :unjoined => ['打算去', '---']
      },
      :play => {
        :joined => ['---', '不去了'],
        :unjoined => ['要去', '---']
      },
      :sided_match => {
        :joined => ['---', '不去了'],
        :undetermined => ['要去', '不去'],
        :unjoined => ['打算去', '---']
      },
    },
    :in =>{
      :training => {
        :joined => ['---', '没去'],
        :undetermined => ['现在去', '不去'],
        :unjoined => ['现在去', '---']
      },
      :play => {
        :joined => ['---', '没去'],
        :unjoined => ['现在去', '---']
      },
      :sided_match => {
        :joined => ['---', '没去'],
        :undetermined => ['现在去', '不去'],
        :unjoined => ['现在去', '---']
      },
    },
    :after =>{
      :training => {
        :joined => ['---', '没去'],
        :undetermined => ['我去了', '我没去'],
        :unjoined => ['去了', '---']
      },
      :play => {
        :joined => ['---', '没去'],
        :unjoined => ['去了', '---']
      },
      :sided_match => {
        :joined => ['---', '没去'],
        :undetermined => ['我去了', '我没去'],
        :unjoined => ['去了', '---']
      },
    },
  }
  
  def time_key(act)
    if (act.start_time > Time.now)
      :before
    elsif (act.start_time < Time.now && act.end_time > Time.now)
       :in
    else
      :after
    end
  end
  
  def type_key(act)
    case act
    when Training
      :training
    when SidedMatch
      :sided_match
    when Play
      :play
    when Match
      :match
    end
  end
  
  def join_key(act)
    if act.class == Play
      if act.has_member?(current_user)
        :joined
      else
        :unjoined
      end
    else
      if act.has_joined_member?(current_user)
        :joined
      elsif act.has_member?(current_user)
        :undetermined
      else
        :unjoined
      end
    end
  end
  
  def time_status_text(act)
    time = time_key(act)
    type = type_key(act)
        
    case STATUS_MATRIX[time][type][:time]
    when String
      STATUS_MATRIX[time][type][:time]
    when nil
      "#{distance_of_time_in_words(act.start_time, Time.now)}之后开始"
    end
  end
    
  def join_status_text(act)
    time = time_key(act)
    type = type_key(act)
    join = join_key(act)
    STATUS_MATRIX[time][type][join]
  end
    
  def join_status_links(act)
    time = time_key(act)
    type = type_key(act)
    join = join_key(act)
    LINKS_MATRIX[time][type][join]
  end
  
  MATCH_STATUS_MATRIX = {
    :before =>{
      :joined => "我要代表%s参赛",
      :undetermined => "代表%s参赛?",
      :unjoined => "我不打算代表%s参赛",
    },
    :in => {
      :joined => "我正代表%s参赛",
      :undetermined => "代表%s参赛?",
      :unjoined => "我没代表%s参赛",
    },
    :after => {
      :joined => "我代表%s去了",
      :undetermined => "代表%s参赛了?",
      :unjoined => "我没代表%s参赛",
    },
  }
    
  MATCH_LINKS_MATRIX = {
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
      :undetermined => ['去了', '没去'],
      :unjoined => ['去了', '---']
    },
  }
  
  def match_join_key(act, team)
    if act.has_joined_team_member?(current_user, team)
      :joined
    elsif act.has_team_member?(current_user, team)
      :undetermined
    else
      :unjoined
    end
  end
  
  def match_join_status_text(act, team, team_name=nil)
    time = time_key(act)
    join = match_join_key(act, team)
    MATCH_STATUS_MATRIX[time][join] % (team_name ? team_name : "#{link_to h(team.shortname), team_view_path(team)}")
  end
    
  def match_join_status_links(act, team)
    time = time_key(act)
    join = match_join_key(act, team)
    MATCH_LINKS_MATRIX[time][join]
  end
end
