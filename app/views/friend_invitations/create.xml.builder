xml.friend_invitation do
	xml.id(@friend_invitation.id)
	xml.apply_date(@friend_invitation.apply_date.to_s(:flex))
	xml.applier_id(@applier.id)
	xml.applier_name(@applier.nickname)	    
	xml.message(@friend_invitation.message)
end