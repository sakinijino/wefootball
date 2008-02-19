xml.friend_invitations do
  for r in @friend_invitations
	  xml.friend_invitation do
	    xml.id(r.id)
	    xml.apply_date(r.apply_date.to_s(:flex))
	    xml.applier_id(r.applier.id)
	    xml.applier_name(r.applier.nickname)	    
	    xml.message(r.message)
	  end
  end
end