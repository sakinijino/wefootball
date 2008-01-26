xml.messages do
  xml.as_sender do
    for s in @as_sender_messages
      xml.message do
        xml.id(s.id)
	xml.sender_id(s.sender_id)
	xml.sender_nick(s.sender.nickname)
	xml.receiver_id(s.receiver_id)
	xml.receiver_nick(s.receiver.nickname)
	xml.subject(s.subject)
	xml.is_receiver_read(s.is_receiver_read)
	xml.created_at(s.created_at)
      end
    end
  end
  xml.as_receiver do
    for r in @as_receiver_messages
      xml.message do	  
        xml.id(r.id)
        xml.sender_id(r.sender_id)
        xml.sender_nick(r.sender.nickname)
        xml.receiver_id(r.receiver_id)
        xml.receiver_nick(r.receiver.nickname)
        xml.subject(r.subject)
        xml.is_receiver_read(r.is_receiver_read)
        xml.created_at(r.created_at)
      end
  end
 end
end