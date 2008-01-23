xml.messages do
  xml.as_sender do
	  for s in @as_sender_messages
	  	xml.message do
		    xml.sender_id(s.sender_id)
		    xml.receiver_id(s.receiver_id)
		    xml.subject(s.subject)
			xml.content(s.content)
		end
	  end
  end
  xml.as_receiver do
	  for r in @as_receiver_messages
	  	xml.message do	  
		    xml.sender_id(r.sender_id)
		    xml.receiver_id(r.receiver_id)
		    xml.subject(r.subject)
			xml.content(r.content)
		end
	  end
  end
end