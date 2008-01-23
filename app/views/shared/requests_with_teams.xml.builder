xml.requests do
  for request in @requests
    xml.id(request.r_id)
    xml.message(request.message)
    xml.apply_date(request.apply_date.to_s(:flex))
    team = request
    xml.team do
      xml.id(team.id)
      xml.login(team.name)
      xml.shorname(team.shortname)
    end
  end
end