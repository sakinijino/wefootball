module QmdHelper
  QMDS = [
    '没事儿踢踢球才是正经事~',
    '小草地二年级足球队~',
    'Debbie,don\'t play football with others...',
    '我爱踢大场~'
  ]
    
  def site_qmd
    QMDS[rand(QMDS.length)]
  end
end
