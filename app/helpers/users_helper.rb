module UsersHelper
   FITFOOT_TEXT = {'L'=>'仅左脚', 'R'=>'仅右脚', 'B'=>'左右开弓'}
   POSITION_TEXT ={
     'GK'=> '门将',
     'SW'=> '清道夫',
     'CB'=> '中后卫',
     'LB'=> '左后卫',
     'RB'=> '右后卫',
     'DM'=> '后腰',
     'CM'=> '中前卫',
     'LM'=> '左前卫',
     'RM'=> '右前卫',
     'AM'=> '前腰',
     'CF'=> '中锋',
     'SS'=> '二前锋',
     'LF'=> '左边锋',
     'RF'=> '右边锋'
    }
  def fitfoot_text(label)
   UsersHelper::FITFOOT_TEXT[label]
  end
  
  def position_text(label)
    UsersHelper::POSITION_TEXT[label]
  end
end