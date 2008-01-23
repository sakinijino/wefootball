xml.user do
  xml.id(@user.id)
  xml.login(@user.login)
  if (!@short_format)
    xml.nickname(@user.nickname)
    xml.height(@user.height, :nil=>@user.height.eql?(nil))
    xml.weight(@user.weight, :nil=>@user.weight.eql?(nil))
    xml.fitfoot(@user.fitfoot, :nil=>@user.fitfoot.eql?(nil))
    xml.birthday((@user.birthday.eql?(nil) ? nil : @user.birthday.to_s(:flex)), :nil=>@user.birthday.eql?(nil))
    xml.summary(@user.summary)
    xml.positions do
      for p in @user.positions
        xml.position(p.label)
      end
    end
  end
end