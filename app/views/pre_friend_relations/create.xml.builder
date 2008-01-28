xml.pre_friend_relation do
	xml.id(@pre_friend_relation.id)
	xml.apply_date(@pre_friend_relation.apply_date.to_s(:flex))
	xml.applier_id(@applier.id)
	xml.applier_name(@applier.nickname)	    
	xml.message(@pre_friend_relation.message)
end