module MatchJoinsHelper
   STATUS_TEXT =[
     '待定', '参加'
    ]
    
  CARD_TEXT = ['无','黄牌','红牌','两黄变一红']
  
  def status_text(label)
    MatchJoinsHelper::STATUS_TEXT[label]
  end

  def card_text(label)
    MatchJoinsHelper::CARD_TEXT[label]
  end
  
end
