module MatchInvitationsHelper
   MATCH_TYPE_TEXTS = {'1'=>'随便玩玩', '2'=>'真刀真枪'}
   WIN_RULE_TEXTS = {'1'=>'自然结束', '2'=>'加时后点球', '3'=> '直接点球'}
     
  def match_type_text(label)
   MatchInvitationsHelper::MATCH_TYPE_TEXTS[label]
  end
end
