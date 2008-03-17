module MatchJoinsHelper
   STATUS_TEXT =[
     '待定', '参加'
    ]
    
  CARD_TEXT = ['无','一黄','直接一红','两黄变一红']
  
  FORMATION_POSITIONS_TEXT = [
    'GK',
    'LB', 'LCB', 'CB', 'RCB', 'RB',
    'LWB', 'LDM', 'DMC', 'RDM', 'RWB',
    'LM', 'LMC', 'MC', 'RMC', 'RM',
    'ALM', 'LAM', 'AMC', 'RAM', 'ARM',
    'LWF', 'LCF', 'CF', 'RCF', 'RWF'
    ] 
  
  def status_text(label)
    MatchJoinsHelper::STATUS_TEXT[label]
  end
  
  def fomation_position_text(label)
    MatchJoinsHelper::FORMATION_POSITIONS_TEXT[label]
  end

  def card_text(label)
    MatchJoinsHelper::CARD_TEXT[label]
  end
end
