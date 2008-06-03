module TopMenuHelper
#  USER_MENU = {
#    :user => Proc.new { |p|
#      p[:controller] == 'user_views'
#    },
#    :friends => Proc.new { |p|
#      p[:controller] == 'friend_invitations' || p[:controller] == 'friend_relations'
#    },
#    :teams => Proc.new { |p|
#      p[:controller] == 'team_joins' || (p[:controller] == 'teams' && p[:action] == 'new') ||
#        p[:controller] == 'team_join_invitations' || p[:controller] == 'team_join_requests'
#    },
#    :activities => Proc.new { |p|
#      p[:controller] == 'calendar' || p[:controller] == 'plays' || 
#        (p[:controller] == 'official_matches' && p[:action] == 'index') ||
#        p[:controller] == 'matches' || p[:controller] == 'match_joins' || 
#        p[:controller] == 'watches' || 
#        p[:controller] == 'sided_matches' || p[:controller] == 'sided_match_joins' ||
#        p[:controller] == 'match_reviews' || p[:controller] == 'match_review_replies'
#    },
#    :messages => Proc.new { |p|
#      p[:controller] == 'messages' || p[:controller] == 'posts' || p[:controller] == 'broadcasts'
#    },
#    :setting => Proc.new { |p|
#      p[:controller] == 'users' && p[:action] == 'edit'
#    }
#  }
#  
#  TEAM_MENU = {
#    :team => Proc.new { |p|
#      p[:controller] == 'team_views'
#    },
#    :members => Proc.new { |p|
#      (p[:controller] == 'team_joins' && p[:action] == 'admin_management') || 
#      (p[:controller] == 'team_joins' && p[:action] == 'index') || 
#        p[:controller] == 'team_join_invitations' || p[:controller] == 'team_join_requests'
#    },
#    :formation => Proc.new { |p|
#      (p[:controller] == 'team_joins' && p[:action] == 'formation_index') || 
#      (p[:controller] == 'team_joins' && p[:action] == 'player_management') ||
#      (p[:controller] == 'team_joins' && p[:action] == 'formation_management')
#    },
#    :activities => Proc.new { |p|
#      p[:controller] == 'calendar' || p[:controller] == 'match_invitations' || 
#        (p[:controller] == 'trainings' && p[:action] == 'new') ||
#        (p[:controller] == 'sided_matches' && p[:action] == 'new')
#    },
#    :posts => Proc.new { |p|
#      p[:controller] == 'posts'
#    },
#    :setting => Proc.new { |p|
#      p[:controller] == 'teams' && p[:action] == 'edit'
#    }
#  }
  
  def is_selected_user_menu_item?(item)
#    USER_MENU[item].call(params) ? 'selected' : ''
    ''
  end
  
  def is_selected_team_menu_item?(item)
#    TEAM_MENU[item].call(params) ? 'selected' : ''
    ''
  end
end
