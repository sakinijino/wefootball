module FootballGroundsHelper
   GROUND_TYPE_TEXT = {1=>'天然草场', 2=>'人工草场', 3=>'硬地场',4=>'土场', 5=>'室内场'}

  def ground_type_text(label)
   FootballGroundsHelper::GROUND_TYPE_TEXT[label]
  end
  
  def location_link(location, fgid)
    if !fgid.nil?
      link_to h(location), football_ground_path(fgid)
    else
      h(location)
    end
  end
end
