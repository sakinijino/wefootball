module UsersHelper
   FITFOOT_TEXT = {'L'=>'仅左脚', 'R'=>'仅右脚', 'B'=>'左右开弓'}
   POSITION_TEXT =[
     '门将', '清道夫', '中后卫', '左后卫', '右后卫', '后腰', '中前卫', '左前卫', '右前卫', '前腰', '中锋', '二前锋', '左边锋', '右边锋'
    ]
  def fitfoot_text(label)
   UsersHelper::FITFOOT_TEXT[label]
  end
  
  def position_text(label)
    UsersHelper::POSITION_TEXT[label]
  end
end