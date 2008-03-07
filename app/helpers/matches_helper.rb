module MatchesHelper
   SITUATION_TEXTS = {1=>'不好说',2=>'狂胜', 3=>'完胜', 4=>'小胜', 5=>'势均力敌',
                      6=>'惜败', 7=>'完败', 8=>'被虐'}
  
  def situation_text(label)
   MatchesHelper::SITUATION_TEXTS[label]
  end             
end
