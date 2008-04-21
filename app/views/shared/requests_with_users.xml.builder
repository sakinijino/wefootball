xml.requests do
  for request in @requests
    xml.id(request.id)
    xml.message(request.message)
    xml.apply_date(request.apply_date.to_s(:flex))
    user = request.user
    xml.user do
      xml.id(user.id)
      xml.login(user.login)
      xml.nickname(user.nickname)
    end
  end
end