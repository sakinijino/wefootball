xml.pre_friend_relations do
  for r in @pre_friend_relations
	  xml.pre_friend_relation do
	    xml.id(r.id)
	    xml.apply_date(r.apply_date.to_s(:flex))
	    xml.applier_id(r.applier.id)
	    xml.applier_name(r.applier.nickname)	    
	    xml.message(r.message)
	  end
  end
end