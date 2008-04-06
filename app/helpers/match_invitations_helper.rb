module MatchInvitationsHelper
   MATCH_TYPE_TEXTS = {1=>'随便玩玩', 2=>'真刀真枪'}
   WIN_RULE_TEXTS = {1=>'直接结束', 2=>'加时赛点球', 3=> '直接点球'}
     
  def match_type_text(label)
   MatchInvitationsHelper::MATCH_TYPE_TEXTS[label]
  end
  
  def win_rule_text(label)
   MatchInvitationsHelper::WIN_RULE_TEXTS[label]
  end  
end
