module TeamJoinsHelper
  TOP_POS_MAP = {0=>520-35, 1=> 520-90, 2=> 520-180, 3=>520-257, 4=>520-347, 5=>520-445}
  LEFT_POS_MAP = {1=>186-135, 2=> 186-65, 3=> 186, 4=>186+65, 0=>186+135}
  
  def team_field_position(pos, formation_array = nil)
    rating = 260 / 372.0
    pos = formation_field_position(pos, formation_array)
    return {:top=>pos[:top]*rating, :left=>pos[:left]*rating}
  end
  
  def formation_field_position(pos, formation_array = nil)
    top = TOP_POS_MAP[((pos-1)/5)+1]
    left = ((pos-1)/5)+1==0 ? LEFT_POS_MAP[3] : LEFT_POS_MAP[pos%5]
    if formation_array
      offset = 15;
      [3, 8, 13, 18, 23].each do |p|
        left+=offset if pos == p-1 && !formation_array.include?(p)
        left-=offset if pos == p+1 && !formation_array.include?(p)
      end
    end
    return {:top=>top-17, :left=>left-18}
  end
  
  def formation_text(formation_array)
    count = {-1=>0, 0=>0, 1=>0, 2=>0, 3=>0, 4=>0}
    formation_array.each do |p|
      count[(p-1)/5]+=1
    end
    if count[0]+count[1]+count[2]+count[3] == 0
      return nil;
    end
    n1 = count[0]
    n4 = count[4]
    if (count[1] !=0 || count[2] !=0) && count[3] !=0 
      n2 = count[1]+count[2]
      n3 = count[3]
    else
      n2 = count[1]+count[2]+count[3]
      n3 = 0
    end
    if n3 == 0
      "#{n1}-#{n2}-#{n4}"
    else
      "#{n1}-#{n2}-#{n3}-#{n4}"
    end
  end
  
  FORMATION_POSITION_TEXT =[
    'GK', 
    'LB', 'CB', 'CB', 'CB', 'RB', 
    'LWB', 'DM', 'DM', 'DM', 'RWB',
    'LCM', 'CM', 'CM', 'CM', 'RCM', 
    'ALM', 'AM', 'AM', 'AM', 'ARM', 
    'LWF', 'CF', 'CF', 'CF', 'RWF'
  ]
  
  def formation_position_text(pos)
    return '替补' if pos == nil
    FORMATION_POSITION_TEXT[pos]
  end
end
