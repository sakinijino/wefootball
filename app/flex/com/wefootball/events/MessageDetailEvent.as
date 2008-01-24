package com.wefootball.events {
	import com.wefootball.model.Message;
	
	import flash.events.Event;
	
	public class MessageDetailEvent extends Event {		
		public var message:Message = new Message
		
		public function MessageDetailEvent(type:String, sender_id:String = "", sender_nick:String = "",
			receiver_id:String = "", receiver_nick:String = "", subject:String="", content:String="") {
			super(type, true);
			this.message.sender_id = sender_id
			this.message.sender_nick = sender_nick
			this.message.receiver_id = receiver_id
			this.message.receiver_nick = receiver_nick
			this.message.subject = subject
			this.message.content = content
		}
	} 
}