xml.requests do
  for request in @requests
    xml.id(request.id)
    xml.message(request.message)
    xml.apply_date(request.apply_date.to_s(:flex))
    team = request.team
    xml.team do
      xml.id(team.id)
      xml.login(team.name)
      xml.shorname(team.shortname)
    end
  end
end