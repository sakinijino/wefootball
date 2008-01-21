xml.user do
  xml.id(@user.id)
  xml.login(@user.login)
  if (!@short_format)
    xml.nickname(@user.nickname)
    xml.height(@user.height)
    xml.weight(@user.weight)
    xml.fitfoot(@user.fitfoot)
    xml.birthday(@user.birthday.to_s)
    xml.summary(@user.summary)
    xml.positions do
      for p in @user.positions
        xml.position(p.label)
      end
    end
  end
end