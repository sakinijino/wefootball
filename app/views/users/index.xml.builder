xml.users do
  for user in @users
    xml.user do
      xml.id(user.id)
      xml.login(user.login)
      xml.nickname(user.nickname)
      xml.height(user.height)
      xml.weight(user.weight)
      xml.fitfoot(user.fitfoot)
      xml.birthday(user.birthday.to_s)
      xml.positions do
        for p in user.positions
          xml.position(p.label)
        end
      end
    end
  end
end