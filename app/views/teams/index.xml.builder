xml.teams do
  for team in @teams
    xml.team do
      xml.id(team.id)
      xml.name(team.name)
      xml.shortname(team.shortname)
    end
  end
end